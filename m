Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1BDGa4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 01:30:56 -0500
Date: Fri, 4 Feb 2011 07:29:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	george0505 <george0505@realtek.com>,
	"'Zhaoming_Li'" <chaoming_li@realsil.com.cn>
Subject: Re: [RFC/RFT 1/8] rtlwifi: Prepare core for addition of USB driver
Message-ID: <20110204062940.GA2222@redhat.com>
References: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net>
 <1296411100-5675-2-git-send-email-Larry.Finger@lwfinger.net>
 <20110203102552.GB3516@redhat.com>
 <4D4B7D92.7000402@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D4B7D92.7000402@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry

On Thu, Feb 03, 2011 at 10:16:18PM -0600, Larry Finger wrote:
> >> +static int _usbctrl_vendorreq_async_write(struct usb_device *udev, u8 request,
> >> +					  u16 value, u16 index, void *pdata,
> >> +					  u16 len, u8 requesttype)
> >> +{
> >> +	int rc;
> >> +	unsigned int pipe;
> >> +	u8 reqtype;
> >> +	struct usb_ctrlrequest *dr;
> >> +	struct urb *urb;
> >> +	struct rtl819x_async_write_data {
> >> +		u8 data[REALTEK_USB_VENQT_MAX_BUF_SIZE];
> >> +		struct usb_ctrlrequest dr;
> >> +	} *buf;
> >> +
> >> +	if (requesttype == VENDOR_READ) {
> >> +		pipe = usb_rcvctrlpipe(udev, 0); /* read_in */
> >> +		reqtype =  REALTEK_USB_VENQT_READ;
> > This is not needed, or function should be named differently not _async_write.
> 
> This one I do not understand. The function does do an asynchronous write. Please
> explain.
If function do "write", then requesttype argument should be removed, and
dr->bRequestType = REALTEK_USB_VENQT_WRITE should be hardcoded.

> >> +	wvalue = (u16)(addr&0x0000ffff);
> >> +	_usbctrl_vendorreq_sync(udev, request, wvalue, index, data, len,
> >> +				requesttype);
> >> +	ret = (le32_to_cpu(*data) & (0xffffffff >> ((4 - len) * 8)));
> > Ok, BYTEMASK can be used, but what mean this magic? 
> 
> As the output of this routine is always cast with (u8) when len is 1 and (u16)
> when len is 2, I think the magic can just disappear and ret can simply be
> 
> 	ret = le32_to_cpu(*data);
Good.

> I will test and have contacted the original author. There is similar magic in
> _usb_write_async() that can also disappear.
> 
> >> +
> >> +	 /* IBSS */
> >> +	 mac->beacon_interval = 100;
> >> +
> >> +	 /* AMPDU */
> >> +	 mac->min_space_cfg = 0;
> >> +	 mac->max_mss_density = 0;
> > Spaces.
> 
> Please explain what you mean by "spaces".
I guess I should wrote "indention". On that lines, there in one space
after tab :-)

Thanks for working on my remarks.
Stanislaw
