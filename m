Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43629 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab1IGShA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 14:37:00 -0400
Received: by yie30 with SMTP id 30so5187502yie.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 11:36:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315419259.4002.16.camel@jlt3.sipsolutions.net>
References: <1315347976-13950-1-git-send-email-javier@cozybit.com>
 <1315418920.4002.13.camel@jlt3.sipsolutions.net> <1315419259.4002.16.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 7 Sep 2011 11:36:37 -0700
Message-ID: <CAPjQAd8ZLDQKvBOMOoe+hoo5FEjiLV6vBxzdE-bMcz_iEt59tQ@mail.gmail.com> (sfid-20110907_203705_147917_D08A7F6E)
Subject: Re: [PATCH 0/2] QoS headers for mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 7, 2011 at 11:14 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-09-07 at 20:08 +0200, Johannes Berg wrote:
>> On Tue, 2011-09-06 at 15:26 -0700, Javier Cardona wrote:
>> > Mesh frames are required to have QoS headers to indicate the presence of a Mesh
>> > Control Header in the payload.  These patches add QoS headers to mesh frames,
>> > but note that they don't implement full QoS support: mesh stations don't
>> > currently advertise QoS capabilities.
>>
>> Uh, so does mesh want full QoS support or just QoS headers? The latter
>> seems a little odd to me. But if it wants QoS how about zd1211rw? I
>> don't think that even supports QoS?
>>
>> That's one thing that bothers me a little bit about this patchset --
>> previously, QoS frames could only happen when the device actually
>> supported 4 queues, now this rule seems to be broken. I don't expect
>> this to be a major issue, but it certainly is unexpected and will
>> probably be forgotten by a lot of people in the future ...
>
> So after looking at this again -- what I'd much rather see instead of
> the second patch, and what will also require fewer changes, is *only*
> doing the change to ieee80211_set_qos_hdr(). Then, if the peer is a QoS
> station, we'll get the right header -- if it isn't then we can't really
> mesh with it but we'll accept that for legacy reasons (for now).
>
> I'd rather not send QoS frames to mesh stations that don't advertise QoS
> capability, and I'd also rather not have to worry about sending QoS
> frames when we don't actually support it locally.

OK.  If QoS support is mandatory for mesh stations, then definitely
that's the way to go.  We'll have to investigate how to advertise QoS
for mesh interfaces:  this is currently not happening even though all
the hardware we use for mesh supports it.
Also, we've never attempted to maintain backward compatibility with
earlier versions of the draft.

Thanks!

Javier



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
