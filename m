Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:61857 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaCaSKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 14:10:07 -0400
Received: by mail-bk0-f54.google.com with SMTP id 6so1221289bkj.41
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 11:10:06 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
Date: Mon, 31 Mar 2014 20:09:46 +0200
Message-ID: <12936014.DUEgOXk110@blech> (sfid-20140331_201013_850557_DBD82929)
In-Reply-To: <5338F1B8.5040305@candelatech.com>
References: <5338F1B8.5040305@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Sunday, March 30, 2014 09:40:24 PM Ben Greear wrote:
> Due to hardware/firmware limitations, it does not appear possible to
> have a wifi NIC do hardware decrypt when using multiple stations on a single
> NIC (and have both stations connected to the same AP).
> 
> This just happens to be one of my favourite things to do, and it kills
> performance compared to normal 'Open' throughput.
> 
> I am curious if anyone knows of any way to accelerate rx-decrypt, perhaps by
> using a specialized hardware board or maybe a feature of certain CPUs?

You could check if your CPU (bios and kernel) have support for AES-NI [0].
AFAICT mac80211 utilizes the cryptoapi. Therefore anything that supports
the proper crypto bindings can be used to accelerate the encryption and
decryption process to some degree. And it just happens that thanks to
AES-NI parts of math can be efficiently calculated by the CPU. 

Regards,
Chr

[0] <http://en.wikipedia.org/wiki/AES_instruction_set>

