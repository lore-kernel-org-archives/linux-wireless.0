Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:16071 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbZBMIXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 03:23:31 -0500
Message-ID: <49952DFD.4050903@gmail.com> (sfid-20090213_092336_602701_78AA003B)
Date: Fri, 13 Feb 2009 09:23:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [PATCH 1/1] ipw2200, fix ipw io functions
References: <1234474180-910-1-git-send-email-jirislaby@gmail.com> <1234486180.6354.203.camel@debian>
In-Reply-To: <1234486180.6354.203.camel@debian>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2009 01:49 AM, Zhu Yi wrote:
> On Fri, 2009-02-13 at 05:29 +0800, Jiri Slaby wrote:
>>  /* alias to 8-bit direct read (low 4K of SRAM/regs), with debug
>> wrapper */
>> -#define ipw_read8(ipw, ofs) __ipw_read8(__FILE__, __LINE__, ipw, ofs)
>> +#define ipw_read8(ipw, ofs) ({ \
>> +       IPW_DEBUG_IO("%s %d: read_direct8(0x%08X)\n", __FILE__, __LINE__, \
>> +                       (u32)(ofs)); \
>> +       _ipw_read8(ipw, ofs); \
>> +})
> 
> Please put a do {} while(0) for this and some of below macros as well.

This is impossible, reads need to return a value...
