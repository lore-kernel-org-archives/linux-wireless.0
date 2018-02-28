Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36836 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752250AbeB1PGI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 10:06:08 -0500
Message-ID: <1519830361.2292.1.camel@sipsolutions.net> (sfid-20180228_160611_762193_CF97B7F4)
Subject: Re: [PATCH] mt7601u: remove a warning in
 mt7601u_efuse_physical_size_check()
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Feb 2018 16:06:01 +0100
In-Reply-To: <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com> (sfid-20180228_152728_270562_022E3D12)
References: <cover.1519827461.git.lorenzo.bianconi@redhat.com>
         <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
         (sfid-20180228_152728_270562_022E3D12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-02-28 at 15:26 +0100, Lorenzo Bianconi wrote:
> 
>  	const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
> -	u8 data[map_reads * 16];
> +	u8 data[round_up(MT_EFUSE_USAGE_MAP_SIZE, 16)];
> 
You could turn it upside down and make 

const int map_reads = ARRAY_SIZE(data);

johannes
