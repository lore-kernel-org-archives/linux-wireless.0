Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:33668 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbYHEW72 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 18:59:28 -0400
Subject: Re: [PATCH 00/19] orinoco: WPA for Agere based cards
From: Pavel Roskin <proski@gnu.org>
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
In-Reply-To: <48978C25.601@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217822232.10989.13.camel@dv>  <48978C25.601@gmail.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 18:59:26 -0400
Message-Id: <1217977166.19480.2.camel@dv> (sfid-20080806_005932_078355_CE10AB98)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-05 at 00:09 +0100, Dave wrote:
> Pavel Roskin wrote:
> >> It is almost checkpatch
> >> clean - the single warning looks like a false positive to me.
> > 
> > If you mean orinoco_ioctl_getnick(), that's a false positive.
> 
> Actually I meant the DECLARE_DEFAULT_PDA macro in hermes_dld.c:
> 
> dkilroy@borken /usr/src/wireless-testing $ git diff HEAD~20 | scripts/checkpatch.pl -
> ERROR: Macros with multiple statements should be enclosed in a do - while loop
> #933: FILE: drivers/net/wireless/hermes_dld.c:570:
> +#define DEFINE_DEFAULT_PDR(pid, length, data)				\
> +static const struct {							\
> +	__le16 len;							\
> +	__le16 id;							\
> +	u8 val[length];							\
> +} __attribute__ ((packed)) default_pdr_data_##pid = {			\
> +	__constant_cpu_to_le16((sizeof(default_pdr_data_##pid)/		\
> +				sizeof(__le16)) - 1),			\
> +	__constant_cpu_to_le16(pid),					\
> +	data								\
> +}

I suggest that you take the structure definition outside the macro and
give it a reasonable name.  

-- 
Regards,
Pavel Roskin
