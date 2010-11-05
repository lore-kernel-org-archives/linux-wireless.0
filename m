Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61463 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0KEKHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 06:07:23 -0400
Received: by qwb8 with SMTP id 8so316335qwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 03:07:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201011051056.03700.helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com>
	<201011051044.37167.helmut.schaa@googlemail.com>
	<AANLkTinDwi_77iVS-bOTSX_4zs76nyttoEsdfpV0_F2g@mail.gmail.com>
	<201011051056.03700.helmut.schaa@googlemail.com>
Date: Fri, 5 Nov 2010 11:07:22 +0100
Message-ID: <AANLkTi=2PBV2nQTqnMwm_hJcq6=jb_E=81mhic9DbqpG@mail.gmail.com>
Subject: Re: [PATCH 03/13] rt2x00: Wait up to one second on rt2800 for WPDMA
 to be ready
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> On Fri, Nov 5, 2010 at 10:44 AM, Helmut Schaa
>> <helmut.schaa@googlemail.com> wrote:
>> > Hi,
>> >
>> > Am Donnerstag 04 November 2010 schrieb Ivo van Doorn:
>> >> From: Helmut Schaa <helmut.schaa@googlemail.com>
>> >>
>> >> At least some devices need such a long time to inititalize WPDMA. This
>> >> only increases the maximum wait time and shouldn't affect devices that
>> >> have been working before.
>> >>
>> >> Reported-by: Joshua Smith <jesmith@kaon.com>
>> >> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> >> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>> >> ---
>> >
>> > Ivo, the patch context looks different then in the version I've send to you.
>> >
>> > The
>> >        for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
>> > should be
>> >        for (i = 0; i < 100; i++) {
>> >
>> > Otherwise we don't wait up to one second as in the comment but just 50ms :P
>> >
>> > However, that change was part of a previous patch that was already merged into
>> > the rt2x00 git tree. Seems like that change got lost during the merge ...
>>
>> I'll try to find the patch which changed the REGISTER_BUSY_COUNT behavior.
>
> I'm not sure but I guess I haven't sent that one as separate [PATCH] but it
> was inlined in the mail traffic with Joshua ("Question about starting up an
> AP").

Ah ok, that explains why I missed it. I'll dig it up, and send it to
wireless-testing
as soon as possible (John, do you want it as separate patch, or should
it be merged
into this patch?).

>> I'm almost worried that more patches have somehow gotten lost (I already noticed
>> that there were a bunch of patches which were send upstream had disappeared
>> from rt2x00.git, but those fortunately reappeared during the last
>> update from wireless-testing).
>
> I haven't noticed any other missing patches till now.

Good.

>> Ivo
>>
>> Ivo
>
> So, you finally decided to clone yourself?

Yes that was a long-lived dream I had. An army of clones of myself... :)

Ivo
