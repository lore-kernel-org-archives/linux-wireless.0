Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:59898 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423232AbcHESEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2016 14:04:10 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave06.hostedemail.com (Postfix) with ESMTP id 05504172641
	for <linux-wireless@vger.kernel.org>; Fri,  5 Aug 2016 17:57:48 +0000 (UTC)
Message-ID: <1470419862.28648.11.camel@perches.com> (sfid-20160805_200415_237731_87CD07A0)
Subject: Re: [PATCH] ath10k: hide kernel addresses from logs using %pK
 format specifier
From: Joe Perches <joe@perches.com>
To: c_mkenna@qti.qualcomm.com, ath10k@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org, mkenna@codeaurora.org,
	Kees Cook <keescook@chromium.org>,
	LKML <linux-kernel@vger.kernel.org>
Date: Fri, 05 Aug 2016 10:57:42 -0700
In-Reply-To: <1470318711-28986-1-git-send-email-c_mkenna@qti.qualcomm.com>
References: <1470318711-28986-1-git-send-email-c_mkenna@qti.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-08-04 at 19:21 +0530, c_mkenna@qti.qualcomm.com wrote:
> From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
> 
> With the %pK format specifier we hide the kernel addresses
> with the help of kptr_restrict sysctl.
> In this patch, %p is changed to %pK in the driver code.
> 
> The sysctl is documented in Documentation/sysctl/kernel.txt.

Maybe %p should follow %pK and only show kernel .text addresses
by default and any other address as 0 unless the sysctl is set.

