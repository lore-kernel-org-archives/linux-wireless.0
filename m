Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64118 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab1IHDes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 23:34:48 -0400
Received: by pzk37 with SMTP id 37so543877pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 20:34:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPjQAd8ZLDQKvBOMOoe+hoo5FEjiLV6vBxzdE-bMcz_iEt59tQ@mail.gmail.com>
References: <1315347976-13950-1-git-send-email-javier@cozybit.com>
 <1315418920.4002.13.camel@jlt3.sipsolutions.net> <1315419259.4002.16.camel@jlt3.sipsolutions.net>
 <CAPjQAd8ZLDQKvBOMOoe+hoo5FEjiLV6vBxzdE-bMcz_iEt59tQ@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 7 Sep 2011 20:34:26 -0700
Message-ID: <CAPjQAd8su+CLkq84L2xtZO3XrKv2RS3fehsYVu2T_5MRwbnQxg@mail.gmail.com> (sfid-20110908_053455_829872_4E80F8B2)
Subject: Re: [PATCH 0/2] QoS headers for mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 7, 2011 at 11:36 AM, Javier Cardona <javier@cozybit.com> wrote:
> On Wed, Sep 7, 2011 at 11:14 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2011-09-07 at 20:08 +0200, Johannes Berg wrote:
>>> On Tue, 2011-09-06 at 15:26 -0700, Javier Cardona wrote:
>>>(...)
>>> Uh, so does mesh want full QoS support or just QoS headers? The latter
>>> seems a little odd to me. But if it wants QoS how about zd1211rw? I
>>> don't think that even supports QoS?
>>> (...)
>> I'd rather not send QoS frames to mesh stations that don't advertise QoS
>> capability, and I'd also rather not have to worry about sending QoS
>> frames when we don't actually support it locally.
>
> OK.  If QoS support is mandatory for mesh stations, then definitely
> that's the way to go.  We'll have to investigate how to advertise QoS
> for mesh interfaces:  this is currently not happening even though all
> the hardware we use for mesh supports it.

Kazuyuki Sakoda, the current technical editor of TGs kindly pointed me
to the right section in the draft:  Sec 5.2.14.3 states that "mesh
STAs are QoS STAs (...) [that] implement a subset of QoS
functionality".  The use of the QoS frame format and EDCA support are
mandatory.

Based on that I'd like to prevent the creation of mesh interfaces on
phy's that don't support multiple queues.  Would you like to suggest a
good place to perform that check?

Thanks!

Javier
