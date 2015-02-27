Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35182 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbbB0IP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 03:15:59 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/9] wil6210: boot loader
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1424001758-29529-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Message-Id: <20150227081559.4250014006E@smtp.codeaurora.org> (sfid-20150227_091603_352900_C923AED6)
Date: Fri, 27 Feb 2015 08:15:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Introduce boot loader. Instead of the operational firmware,
> very small boot loader is burned to the on-board flash. Boot loader
> initializes hardware upon reset, and prepares for low power mode.
> Boot loader reports MAC address and detects radio chip connected.
> 
> Driver loads firmware only when bringing up interface. All information
> required to set up network interface, most important is MAC address,
> reported by the boot loader
> 
> The firmware composed of 2 files:
> - wil6210.fw - firmware itself (compiled code + data)
> - wil6210.board - board file (various board and radio dependent
>   calibrations and parameters)
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, 8 patches applied to wireless-drivers-next.git:

2cd0f021b847 wil6210: boot loader
9a5511b58b25 wil6210: remove support for old hardware
e3351277ac58 wil6210: enable fix for HW bug in 802.11->803.3 transform
33c477fdab25 wil6210: branch prediction hints
0436fd9a2d1e wil6210: Change of threshold for tx vring idleness measurement
8f55cbec7f88 wil6210: Fix division by zero in wil_vring_debugfs_show
774974e50432 wil6210: rename 'secure_pcp' to 'privacy'
344a7024e01f wil6210: track privacy connection attribute

Kalle Valo
