Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34475 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2DYGtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:49:49 -0400
Message-ID: <4F979E88.2020009@qca.qualcomm.com> (sfid-20120425_084952_972184_C179D1DB)
Date: Wed, 25 Apr 2012 09:49:44 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] wireless: properly use pr_fmt()
References: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org>
In-Reply-To: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2012 05:36 AM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
> 
> pr_fmt() is either defined or we redefine it. Typically
> drivers define it prior to including printk.h but this
> is done under the assumption that no other subsystem
> it uses has already defined pr_fmt(). In such cases
> pr_fmt() should be undefined and redefined.
> 
> Doing this properly shaves down compilation time quite
> considerably.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
> ---
> 
> I left out only ath6kl as ath6kl folks get groggy it seems
> if you do not go through their tree. Bleh.

Yeah, I prefer ath6kl patches going to ath6kl.git first just to avoid
conflicts when merging. But simple patches like this are not an issue,
conflicts are unlikely or are easy to fix.

Kalle
