Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:32914 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515Ab0KVUwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 15:52:13 -0500
Message-ID: <4CEAD7FA.1060107@openwrt.org>
Date: Mon, 22 Nov 2010 21:52:10 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k_hw: fix endian issues with CTLs on AR9003
References: <1290279018-29716-1-git-send-email-nbd@openwrt.org> <20101122201511.GG2117@tuxdriver.com>
In-Reply-To: <20101122201511.GG2117@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-22 9:15 PM, John W. Linville wrote:
> On Sat, Nov 20, 2010 at 07:50:18PM +0100, Felix Fietkau wrote:
>> Parsing data using bitfields is messy, because it makes endian handling
>> much harder. AR9002 and earlier got it right, AR9003 got it wrong.
>> Fix it by getting rid of the CTL related bitfields entirely and use
>> masks instead.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Cc: stable@kernel.org
> 
> Why does this merit stable consideration?
It's a simple fix and I would like it to make it to stable releases,
because this bug might possibly cause the tx power to be too high in
some instances (when running on big-endian systems), violating
regulatory limits.

- Felix
