Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40309 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1FNRBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 13:01:11 -0400
Received: by bwz15 with SMTP id 15so4128153bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 10:01:10 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: ShawnG <swggator4@gmail.com>
Subject: Re: DWA-160
Date: Tue, 14 Jun 2011 19:01:46 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTim0mV230taAmbTm_Rm0wfPBGAznhw@mail.gmail.com> <201106141637.54930.chunkeey@googlemail.com> <BANLkTi==3RDG9_Hu1f1YjyBEnvEXtpj++A@mail.gmail.com>
In-Reply-To: <BANLkTi==3RDG9_Hu1f1YjyBEnvEXtpj++A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201106141901.47190.chunkeey@googlemail.com> (sfid-20110614_190115_257111_E89026EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 June 2011 16:47:45 ShawnG wrote:
> I forgot to ask this, does the AR9170 hardware FCS calculation have a bug,
> because we see garbage packets quite frequently?

Depends on how you operate the device
[as client or AP, with 11n-draft or just b/g].

Obviously, if you use HW crypto offload [default] on one interface and
capture frames on an extra monitor interface on the same device, the
FCS will always be wrong for protected data frames  because the HW
has already decrypted the frame, but left the original FCS
[for the encrypted frame]  in place.

Also, you should tell your capture tool not to enable promisc mode
[most enable it by default], because this also affects the FCS check.

So much for the "duh!" cases.

However, this might not be the whole story, in fact I've seen weird data frames
as well [with different HW, but no matter]. I don't think the FCS check per se is
buggy. The hardware seems to receive and verify the frames just fine, but
somehow the frame's content get corrupted along the way to the driver.

[Note: The reason why I think this is more likely is because the
hardware also "sends" occasionally garbage frames but with a
correct FCS!

this was detected by a case we had a while ago:
mac80211: ignore non-bcast mcast deauth/disassoc frames"]

What I don't know if behavior is caused by a incorrect register value
somewhere, or by a hardware bug.

However,  if you have a "normal" PC,  you can always set
nohwcrypt=1. This will fix the issue for good, because the
garbage data frames will then be dropped by the message
integerty check.

Regards,
	Chr
