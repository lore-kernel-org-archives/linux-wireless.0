Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40527 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab0GAApQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 20:45:16 -0400
Message-ID: <4C2BE50F.1080108@openwrt.org>
Date: Thu, 01 Jul 2010 02:45:03 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?ISO-8859-1?Q?Bj=F6rn_Sm?= =?ISO-8859-1?Q?edman?=
	<bjorn.smedman@venatech.se>
Subject: Re: [PATCH] ath9k: fix TSF after reset on AR913x
References: <4C2A8AD4.8070504@openwrt.org> <1277935351.17170.1.camel@mj>
In-Reply-To: <1277935351.17170.1.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-01 12:02 AM, Pavel Roskin wrote:
> On Wed, 2010-06-30 at 02:07 +0200, Felix Fietkau wrote:
>> +	if (AR_SREV_9100(ah) && (ath9k_hw_gettsf64(ah) < tsf)) {
>> +		tsf += 1500;
> 
> Why 1500?  Is it a magic number?  It is a result of some measurement?
> Can we have a define for it, please?
The comment right above already explains it. This is the 'offset based
on measured time difference'

- Felix
