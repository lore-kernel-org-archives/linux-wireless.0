Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51386 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab0DSTHo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 15:07:44 -0400
Message-ID: <4BCCA9F9.6070508@openwrt.org>
Date: Mon, 19 Apr 2010 21:07:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH v2 1/9] ath9k: check for specific rx stuck conditions
 and recover from them
References: <1271699857-12366-1-git-send-email-nbd@openwrt.org> <1271703852.19879.1.camel@mj>
In-Reply-To: <1271703852.19879.1.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-19 9:04 PM, Pavel Roskin wrote:
> On Mon, 2010-04-19 at 19:57 +0200, Felix Fietkau wrote:
>> +		if ((reg & 0x7E7FFFEF) == 0x00702400)
>> +			continue;
>> +
>> +		switch (reg & 0x7E000B00) {
>> +		case 0x1E000000:
>> +		case 0x52000B00:
>> +		case 0x18000B00:
>> +			continue;
> 
> Where did you get all that magic?  If it's from Atheros documentation,
> maybe you could give those numbers descriptive names?
I don't have any names for that. It's stuff from a debugging register -
adapted from Atheros code...

- Felix
