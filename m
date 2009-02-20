Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:33603 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbZBTT2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 14:28:52 -0500
Received: by bwz5 with SMTP id 5so2923841bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 11:28:49 -0800 (PST)
Message-ID: <499F046E.2090609@gmail.com> (sfid-20090220_202900_726431_F1B5CEA8)
Date: Fri, 20 Feb 2009 19:28:46 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: orinoco-devel@lists.sourceforge.net
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] orinoco: prevent accessing memory outside the firmware
 image
References: <1235087187-23425-1-git-send-email-kilroyd@googlemail.com> <1235087187-23425-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1235087187-23425-3-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Kilroy wrote:
> Do this by indicating the end of the appropriate regions of memory.
> 
> Note that MAX_PDA_SIZE should only apply to the PDA block read from
> flash/EEPROM, and has been erronously applied to the pdr elements.
> Remove the macro, and use the actual PDA size passed down by the caller.
> 
> We also fix up some of the types used, marking as much as possible
> const, and using void* for the end pointers.
> 
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> ---

I've missed (at least) a couple places where I need to add checks:

 * When looking for PDR for Symbol firmware.
 * When applying PDR data I need to check the data is within the FW image

I'll update this patch, address Andreys comments on the other, and resubmit.


Dave.
