Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35375 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJCMLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2014 08:11:14 -0400
Date: Fri, 3 Oct 2014 15:11:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: c_manoha@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: re: ath: Add support for tracing
Message-ID: <20141003121101.GA23748@mwanda> (sfid-20141003_141117_927863_7DCE9893)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Sujith Manoharan,

This is a semi-automatic email about new static checker warnings.

The patch e6664dff0608: "ath: Add support for tracing" from Sep 27, 
2014, leads to the following Smatch complaint:

drivers/net/wireless/ath/main.c:88 ath_printk()
	 error: we previously assumed 'common->hw' could be null (see line 82)

drivers/net/wireless/ath/main.c
    81	
    82		if (common && common->hw && common->hw->wiphy)
                              ^^^^^^^^^^
Existing code assumes common->hw can be NULL.

    83			printk("%sath: %s: %pV",
    84			       level, wiphy_name(common->hw->wiphy), &vaf);
    85		else
    86			printk("%sath: %pV", level, &vaf);
    87	
    88		trace_ath_log(common->hw->wiphy, &vaf);
                              ^^^^^^^^^^^^^^^^^
New code dereferences it without checking for NULL.

    89	
    90		va_end(args);

regards,
dan carpenter
