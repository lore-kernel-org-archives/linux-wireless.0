Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbbISE7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 00:59:14 -0400
Date: Fri, 18 Sep 2015 19:45:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, rachel.kim@atmel.com,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	"tony.cho" <tony.cho@atmel.com>, leo.kim@atmel.com
Subject: Re: [PATCH V2 3/8] staging: wilc1000: replace int8_t with int
Message-ID: <20150919024516.GA21543@kroah.com> (sfid-20150919_065918_796737_9704FB53)
References: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
 <1442476129-14908-3-git-send-email-chaehyun.lim@gmail.com>
 <20150917103426.GB20514@sudip-pc>
 <CAKV=isvZ2V+RgpB_Aej5cUjZ+n_9OdOb2X_0f=q6=LNouxF14A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKV=isvZ2V+RgpB_Aej5cUjZ+n_9OdOb2X_0f=q6=LNouxF14A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 17, 2015 at 09:03:14PM +0900, Chaehyun Lim wrote:
> On Thu, Sep 17, 2015 at 7:34 PM, Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> > On Thu, Sep 17, 2015 at 04:48:44PM +0900, Chaehyun Lim wrote:
> >> This patch replaces int8_t with int. just use return type as int.
> >>
> >> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> >> ---
> > but isn't int8_t is defined as char?
> >
> 
> Even int8_t is defined as char, I think it's no problem to use int.
> Is it need to change as char?

No, you need to make it a u8 (or s8, depending on the usage).  Be very
careful when changing variable widths.

thanks,

greg k-h
