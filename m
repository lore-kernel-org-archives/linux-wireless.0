Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41740 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1AGCpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:45:34 -0500
Message-ID: <4D267E47.6050408@openwrt.org>
Date: Thu, 06 Jan 2011 19:45:27 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [ath9k-devel] [PATCH 3/3] ath9k: Keep track of stations for debugfs.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-3-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294361165-15308-3-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-06 5:46 PM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> The stations hold the ath_node, which holds the tid
> and other xmit logic structures.  In order to debug
> stuck xmit logic, we need a way to print out the tid
> state for the stations.
>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
I really don't like the array with the hardcoded size. How about just 
adding a struct list_head to the ath_node struct and tracking that?

- Felix
