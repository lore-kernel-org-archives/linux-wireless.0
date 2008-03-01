Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:34952 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbYCABj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 20:39:58 -0500
Received: by wa-out-1112.google.com with SMTP id v27so5100439wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 29 Feb 2008 17:39:57 -0800 (PST)
Message-ID: <f19298770802291739j32b8dbaeu36ec66302d88ddb2@mail.gmail.com> (sfid-20080301_014000_532751_56107874)
Date: Sat, 1 Mar 2008 04:39:57 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH stable] b43: Backport bcm4311 fix
Cc: "Michael Buesch" <mb@bu3sch.de>, stable@kernel.org,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <20080301002919.GA17761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200802291255.41906.mb@bu3sch.de>
	 <20080301002919.GA17761@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 1, 2008 at 3:29 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Feb 29, 2008 at 12:55:41PM +0100, Michael Buesch wrote:
>  >     The changes include the following:
>  >
>  >     (1) Add the 802.11 rev 13 device to the ssb_device_id table to load b43.
>  >     (2) Add PHY revision 9 to the supported list.
>  >     (3) Change the 2-bit routing code for address extensions to 0b10 rather
>  >         than the 0b01 used for the 32-bit case.
>  >     (4) Remove some magic numbers in the DMA setup.
>  >
>  >     The DMA implementation for this chip supports full 64-bit addressing with
>  >     one exception. Whenever the Descriptor Ring Buffer is in high memory, a
>  >     fatal DMA error occurs. This problem was not present in 2.6.24-rc2 due
>  >     to code to "Bias the placement of kernel pages at lower PFNs". When
>  >     commit 44048d70 reverted that code, the DMA error appeared. As a "fix",
>  >     use the GFP_DMA flag when allocating the buffer for 64-bit DMA. At present,
>  >     this problem is thought to arise from a hardware error.
>
>  Is this logic upstream in 2.6.25-rcX already?  If so, do you have a git
>  id for it so that I can match them up?
>

Commit 013978b688d2a27af3ab55ca739e8c8ac7254870


>  thanks,
>
>  greg k-h
>
