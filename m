Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:38740 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbbCMGrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 02:47:46 -0400
Received: by wevk48 with SMTP id k48so21175980wev.5
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:47:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426175362-8640-1-git-send-email-hofrat@osadl.org>
References: <1426175362-8640-1-git-send-email-hofrat@osadl.org>
Date: Fri, 13 Mar 2015 07:47:45 +0100
Message-ID: <CA+BoTQ=VYkOcKBjBuLsJcDjPNevTD2UFxVfB1uimRr=9uBO4Fw@mail.gmail.com> (sfid-20150313_074806_510740_46830AD5)
Subject: Re: [PATCH 2/3 RFC] ath10k: wmi: match wait_for_completion_timeout
 return type
From: Michal Kazior <michal.kazior@tieto.com>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Network Development <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 March 2015 at 16:49, Nicholas Mc Guire <hofrat@osadl.org> wrote:
> Return type of wait_for_completion_timeout is unsigned long not int.
> An appropriately named unsigned long is added and the assignments fixed up.
> Rather than returning 0 (timeout) or a more or less random remaining time
> (completion success) this return 0 or 1 which also resolves the type of the
> functions being int.
>
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
>
> Checking the call-sites of ath10k_wmi_wait_for_unified_ready and
> ath10k_wmi_wait_for_service_ready the positive return value (remaining
> time in jiffies) is never passed up the call-chain nor used so it is
> cleaner to treat this like a boolean success/fail only (actually the two
> functions should probably be of type bool - but that does not seem to be
> common practice in the ath10k code base)

It'd make sense to have these functions return 0 or -ETIMEDOUT. In
that case both call sites would need to be adjusted to treat "< 0" or
"!x" as an error (instead of the current "<= 0") condition and not set
-ETIMEDOUT themselves.


Michał
