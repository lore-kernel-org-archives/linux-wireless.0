Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:47976 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751029AbaBSWcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 17:32:01 -0500
Message-ID: <1392849119.24844.17.camel@joe-AO722> (sfid-20140219_233207_106774_FE8D19C3)
Subject: Re: [PATCH 4/4] staging: vt6656: Remove typedef enum _CONTEXT_TYPE
From: Joe Perches <joe@perches.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 14:31:59 -0800
In-Reply-To: <5305304B.5050004@gmail.com>
References: <1392846993.20211.15.camel@canaries64-MCP7A>
	 <1392848134.24844.16.camel@joe-AO722> <5305304B.5050004@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 22:29 +0000, Malcolm Priestley wrote:
> On 19/02/14 22:15, Joe Perches wrote:
> > On Wed, 2014-02-19 at 21:56 +0000, Malcolm Priestley wrote:
> >> Replace with enum
> >> assign as u8 type.
> > []
> >> diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
> > []
> >> @@ -180,7 +180,7 @@ struct vnt_usb_send_context {
> >>   	struct sk_buff *pPacket;
> >>   	struct urb *pUrb;
> >>   	unsigned int uBufLen;
> >> -	CONTEXT_TYPE Type;
> >> +	u8 type;
> >
> > This doesn't really save any space in the struct.
> > You might move it immediately before or after bBoolInUse.
> >
> >>   	struct ethhdr sEthHeader;
> >>   	void *Next;
> >>   	bool bBoolInUse;
> >
> >
> No, but there are dead members in the structure that need removing.
> 
> sEthHeader and Next are dead

Then it'll all work out well in the end...

