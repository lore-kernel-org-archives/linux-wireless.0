Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57162 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaAPLZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 06:25:09 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21207.49245.151249.759167@gargle.gargle.HOWL> (sfid-20140116_122512_877414_4C198128)
Date: Thu, 16 Jan 2014 16:49:57 +0530
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
In-Reply-To: <21207.48441.292580.481850@gargle.gargle.HOWL>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
	<1384665016-12022-5-git-send-email-sujith@msujith.org>
	<52CE934D.1020400@neratec.com>
	<21198.40916.260973.48444@gargle.gargle.HOWL>
	<52CEA5A3.2040308@neratec.com>
	<21198.43395.235654.597422@gargle.gargle.HOWL>
	<52CEAB24.5090700@neratec.com>
	<52D3F962.1010302@neratec.com>
	<21204.319.492595.58625@gargle.gargle.HOWL>
	<52D402C3.3070606@neratec.com>
	<21204.1991.201080.986559@gargle.gargle.HOWL>
	<21204.2384.710460.402183@gargle.gargle.HOWL>
	<21204.3832.404821.109119@gargle.gargle.HOWL>
	<52D63EBB.7020607@neratec.com>
	<21206.17284.157496.206327@gargle.gargle.HOWL>
	<52D6472B.2060207@neratec.com>
	<21207.48441.292580.481850@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> We could fix this by checking if we are initializing the history for the operating
> channel and waiting for NF-cal completion, but I am not sure if this needs
> to be done. The window is really small and subsequent NF calibrations using
> the ANI routine work properly.

Also, this is a bad idea in general since NF calibration has to
wait for the medium to become idle - problematic when there is heavy
interference or general WLAN usage.

Sujith
