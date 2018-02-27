Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38610 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751117AbeB0Jl7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 04:41:59 -0500
Date: Tue, 27 Feb 2018 12:41:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 8/8] staging: wilc1000: fix open parenthesis mismatch
 issue in wilc_wlan_cfg_set()
Message-ID: <20180227094140.tad4smuvfvkzmx6m@mwanda> (sfid-20180227_104205_037200_75CAF8AC)
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
 <1519662722-15761-9-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519662722-15761-9-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first 5 patches are good, but the last 3 are not OK.

Normally "tmp" is used as an iterator pointer or something along those
lines.  For example, here is a good use of "tmp".

	tmp = left;
	left = right;
	right = tmp;

In this example, you want to store a pointer temporarily, so what else
are you going to call it besides "tmp"?  The name "tmp" doesn't mean
"I want a short name and I'm too lazy to think of one".

regards,
dan carpenter
