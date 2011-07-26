Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44511 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1GZUUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 16:20:08 -0400
Received: by yia27 with SMTP id 27so549826yia.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 13:20:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107262031.11394.chunkeey@googlemail.com>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <COL114-W76260EA23039CA8000DB88A320@phx.gbl>
 <CAB=NE6Wcn3-GwqPJQDXOT0JCNnZgCs1E7HecWrXpc8LS+XRyDA@mail.gmail.com> <201107262031.11394.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 Jul 2011 13:19:48 -0700
Message-ID: <CAB=NE6WoGZfpGnNkdaLdtN+nC+aM1mxV4rkUCMarnuDonQeJeg@mail.gmail.com> (sfid-20110726_222012_304412_66985B59)
Subject: Re: problem on ACS
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: MingAnn Ng <devil_eddie01@hotmail.com>,
	wireless testing <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 26, 2011 at 11:31 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Tuesday, July 26, 2011 08:21:21 PM Luis R. Rodriguez wrote:
>
>> Hm, as for the new values -- they look very different from what you
>> had gotten before so the math went wrong somewhere.. gotta revise that
>> a bit more carefully.
>
> well, take a close look at the patch.
>
>> -       factor *= (base_to_power(2, survey->noise - min_noise));
>> +              factor += survey->noise + min_noise;
>
> In the original version, you substracted the min band noise from the
> channel. Whereas now you add them together.

Ah yes, my documentation was just off, and that is correct as the
original intention was to use the noise as an amplifier of of the
computed values of "business". In this case we first get the min noise
of the band and then get the delta between the observed noise and the
min. This ensured that the amplification factor here would yield 1 as
2^0 is 1, and then really high values where the delta was higher.

>> > The result is almost the same as the version before applying the patch. the
>> > -inf still fall on those channel. and those channel are indeed very busy in
>> > my lab. Is there any other solution which I can try to get a better result
>> > out of it?
>> >
>> > I haven't try on the latest patch for hostapd which you uploaded. Is the acs
>> > application work along with hostapd to calculate the interference level?
>>
>> No, the ACS implementation on hostapd simply uses the internal code
>> from hostapd so its much easier to write, the acs.git code is
>> completely independent so adding anything there is just a bit harder,
>> for example adding a scan prior to the ACS work. Please do try the
>> hostapd patches to see if you get a good channel, and enable debugging
>> to see the values you get. We do want to avoid the -inf stuff
>> completely. Getting that means our data type is not sufficient for our
>> data. The difficult aspect of this code is that the values range from
>> fractional values to extremely large values..
>
> well, if you do a [active] scan. channel_time_tx + channel_time_busy will
> definetly not be "zero".

That's fine though, but I do also prefer to avoid TX'ign data, which
is why I used the offchannel operation instead, but we could do
passive scans.

> Maybe we can get away by adding some threshold
> cuts-offs. At least this would fix the -inf.
>
> +       factor = log2(max(1, survey->channel_time_busy - survey->channel_time_tx));
> +       factor -= log2(max(1, survey->channel_time - survey->channel_time_tx));

Hm, the threshold cut off idea sound great, however the assumption
here is that busy time is always > tx time and active time is also
always > tx time, this should ensure at least a value of 1 is used,
given that we at least have to go offchannel for at least 1ms. What do
you see that would make these values go < 1?

> [However, we could also ignore channel surveys with result in a -inf]

the issue might be more with the values being *too big*, not too
small, so we'd could use a min instead, to ensure we bound our
computation by the data type used, something like:

+       factor = log2(min(2^30, survey->channel_time_busy -
survey->channel_time_tx));
+       factor -= log2(min(2^30, survey->channel_time -
survey->channel_time_tx));

In fact 2^30 is the highest value that fits into long double so lets
stick with that, and since we have an addition I've tested we can add
log2(2^30) + log2(2^30). I've pushed the changes into acs.git and will
now use this same compuation for hostapd and respin those patches.

  Luis
