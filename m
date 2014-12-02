Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:40019 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751508AbaLBPHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 10:07:51 -0500
Message-ID: <1417532867.3365.1.camel@perches.com> (sfid-20141202_160754_964480_3C6F1019)
Subject: Re: [PATCH v2 02/10] wil6210: introduce wil_err_ratelimited()
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Date: Tue, 02 Dec 2014 07:07:47 -0800
In-Reply-To: <1417513598-18304-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1417513598-18304-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-02 at 11:46 +0200, Vladimir Kondratiev wrote:
> Add rate-limited flavor of wil_err(); in some cases,
> specially in IRQ and data path, if something went wrong,
> error message may be printed at very high rate, rendering
> whole system unresponsive or unstable.
> Need to do real function and not a macro to have arguments
> always evaluated.

net_<foo>_ratelimited uses the same form.

include/linux/net.h:#define net_ratelimited_function(function, ...)             
include/linux/net.h-do {                                                        
include/linux/net.h-    if (net_ratelimit())                                    
include/linux/net.h-            function(__VA_ARGS__);                          
include/linux/net.h-} while (0)

include/linux/net.h-#define net_err_ratelimited(fmt, ...)                       
include/linux/net.h:    net_ratelimited_function(pr_err, fmt, ##__VA_ARGS__)


