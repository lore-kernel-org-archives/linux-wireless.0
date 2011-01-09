Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41817 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab1AISIa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 13:08:30 -0500
Message-ID: <4D29F995.1000007@openwrt.org>
Date: Sun, 09 Jan 2011 11:08:21 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] ath9k: set hw opmode while changing interface type
References: <1294591888-16625-1-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1294591888-16625-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-09 9:51 AM, Rajkumar Manoharan wrote:
> The commit "ath9k: Add change_interface callback" is
> failed to set hw opmode while changing interface type
> on runtime. Not setting opmode fails to generate
> beacons on changing to AP mode.
>
> Cc: stable@kernel.org
> Cc: Jouni Malinen<Jouni.Malinen@Atheros.com>
> Signed-off-by: Rajkumar Manoharan<rmanoharan@atheros.com>
> ---
>   drivers/net/wireless/ath/ath9k/beacon.c |    1 +
>   drivers/net/wireless/ath/ath9k/main.c   |    4 ++++
>   2 files changed, 5 insertions(+), 0 deletions(-)
>
I'm really not convinced that this is enough. How about implementing 
proper code for recalculating ah->opmode and doing hw resets when 
necessary, instead of adding more band-aids that can only deal with 
having only one interface. This patch really only fixes a few visible 
parts of the problem, but in the details the ath9k_change_interface 
callback still somewhat broken.

I think since not only ah->opmode matters, but also various other things 
that conditionally enable/disable ANI, various flags in ah->imask, etc. 
it would probably be best to merge most of the code of .add_interface, 
.remove_interface and .change_interface into one function that iterates 
over all active interfaces and calculates all the mode dependent 
parameters. The way things are done right now is just too fragile.

- Felix

