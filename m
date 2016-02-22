Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53956 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbcBVKQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 05:16:23 -0500
Subject: Re: [PATCH] rtlwifi: pass struct rtl_stats by reference as it is more
 efficient
To: Alexander Stein <alexander.stein@systec-electronic.com>,
	linux-kernel@vger.kernel.org
References: <1456006227-10709-1-git-send-email-colin.king@canonical.com>
 <1498532.AoNxxa1Kry@ws-stein>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	Priit Laes <plaes@plaes.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <56CADFF4.409@canonical.com> (sfid-20160222_111643_000844_4E7521BF)
Date: Mon, 22 Feb 2016 10:16:20 +0000
MIME-Version: 1.0
In-Reply-To: <1498532.AoNxxa1Kry@ws-stein>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/02/16 06:51, Alexander Stein wrote:
> On Saturday 20 February 2016 22:10:27, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> passing rtl_stats by value is inefficient; the structure is over 300
>> bytes in size and generally just one field (packet_report_type)
>> is being accessed, so the pass by value is a relatively large overhead.
>> This change just affects just the rx_command_packet calls.
> 
> Why not using a const pointer?

const struct rtl_stats *const status?

> 
> Best regards,
> Alexander
> 

