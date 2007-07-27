Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56494
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762247AbXG0LYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 07:24:35 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH 09/17] iwlwifi: EEPROM reading fix
Date: Fri, 27 Jul 2007 13:22:49 +0200
Cc: linville@tuxdriver.com, ipwpatch@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com> <11855284161716-git-send-email-yi.zhu@intel.com> <11855284183313-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284183313-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200707271322.50303.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 July 2007 11:26:33 Zhu Yi wrote:
>  		if (!(r & 1)) {
>  			IWL_ERROR("Time out reading EEPROM[%d]", addr);
> -			return -ETIMEDOUT;
> +			rc = -ETIMEDOUT;
> +			goto done;
>  		}
>  
>  		e[addr / 2] = le16_to_cpu(r >> 16);

Seems like you really want cpu_to_le16() here, as "r" should better
be CPU-endian when shifting it by >>.

Though, I don't see enough code context here to judge if the
endianess conversion is correct at all or not.

-- 
Greetings Michael.
