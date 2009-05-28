Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:49708 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764128AbZE1VQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 17:16:46 -0400
Received: by pxi29 with SMTP id 29so1201737pxi.33
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2009 14:16:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090528192601.GD20870@tesla>
References: <1243475326-28867-1-git-send-email-lrodriguez@atheros.com>
	<1243475326-28867-2-git-send-email-lrodriguez@atheros.com>
	<200905281803.44198.chunkeey@web.de> <20090528192601.GD20870@tesla>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 28 May 2009 14:16:28 -0700
Message-ID: <43e72e890905281416q4e38f615l387d471f323a492c@mail.gmail.com>
Subject: Re: [otus-devel] [RFT 1/2] ar9170: add initial support for 1-stage
	firmware
To: Christian Lamparter <chunkeey@web.de>
Cc: "otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>,
	Yuan-Gu Wei <Yuan-Gu.Wei@atheros.com>,
	Johnny Cheng <Johnny.Cheng@atheros.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Peter Grabienski <Peter.Grabienski@atheros.com>,
	Michael Fortin <Michael.Fortin@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 28, 2009 at 12:26 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, May 28, 2009 at 09:03:43AM -0700, Christian Lamparter wrote:

>> --> #if_N_def ZM_OTUS_LINUX_PHASE_2 <--
>> zfDelayWriteInternalReg(dev, 0x1c3694, ((hpPriv->tPow2x2g[0]&0x3f) << 20) | (0x5<<26));
>> zfDelayWriteInternalReg(dev, 0x1c3bb4, ((hpPriv->tPow2x2g[0]&0x3f) << 5 ) | (0x5<<11) |
>>                                            ((hpPriv->tPow2x2g[0]&0x3f) << 21) | (0x5<<27)  );
>> #endif
>> so, the current ar9170 code is actually _wrong_ (but works!)...
>> and we should not touch these fields with the 2-stage firmware.
>
> Oh, hm, yeah good catch, but to match would actually need to call it
> when stage-1 firmware is used.
>
>> OT: since the firmware will (inevitably end up in the firmware-git-tree)
>> we should convert it to ihex, so it can be downloaded with the git-web.
>> (this can be done by: objcopy -I binary -O ihex ar9170.fw ar9170.fw.ihex )
>
> Sure, whatever works best. If you download it from gitweb you then
> have to do the conversion back though.

I noticed some difference in performance wit this removed so I think
for now its best to leave it in for both -- it seems this sets the ACK
power.

  Luis
