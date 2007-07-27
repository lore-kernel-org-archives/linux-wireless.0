Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.238]:62041 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936239AbXG0WYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 18:24:43 -0400
Received: by wx-out-0506.google.com with SMTP id h31so875931wxd
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2007 15:24:42 -0700 (PDT)
Message-ID: <1ba2fa240707271524i591ed932jd3f2998ba6203ad8@mail.gmail.com>
Date: Fri, 27 Jul 2007 15:24:42 -0700
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 09/17] iwlwifi: EEPROM reading fix
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	ipwpatch@vger.kernel.org, linux-wireless@vger.kernel.org,
	"Gregory Greenman" <gregory.greenman@intel.com>
In-Reply-To: <200707271322.50303.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11855284012123-git-send-email-yi.zhu@intel.com>
	 <11855284161716-git-send-email-yi.zhu@intel.com>
	 <11855284183313-git-send-email-yi.zhu@intel.com>
	 <200707271322.50303.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/27/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 27 July 2007 11:26:33 Zhu Yi wrote:
> >               if (!(r & 1)) {
> >                       IWL_ERROR("Time out reading EEPROM[%d]", addr);
> > -                     return -ETIMEDOUT;
> > +                     rc = -ETIMEDOUT;
> > +                     goto done;
> >               }
> >
> >               e[addr / 2] = le16_to_cpu(r >> 16);
>
> Seems like you really want cpu_to_le16() here, as "r" should better
> be CPU-endian when shifting it by >>.
>
> Though, I don't see enough code context here to judge if the
> endianess conversion is correct at all or not.
>
This line is empirically correct. The value r is indeed cpu ordered 32
bit value  I agree that it is a bit awkward but  the reason is in how
the register value is composed in the HW.

Thanks for the comment.
Tomas

> --
> Greetings Michael.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
