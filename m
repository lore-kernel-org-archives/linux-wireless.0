Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52163 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaCYJNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 05:13:30 -0400
Received: by mail-pb0-f41.google.com with SMTP id jt11so180833pbb.28
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 02:13:30 -0700 (PDT)
Date: Tue, 25 Mar 2014 17:13:21 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] rtlwifi: add MSI interrupts support
Message-ID: <20140325091321.GA9241@adam-laptop> (sfid-20140325_101417_578361_F5479C62)
References: <1395640841-14477-1-git-send-email-adam.lee@canonical.com>
 <1395660884-15042-1-git-send-email-adam.lee@canonical.com>
 <53304BBE.6040403@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53304BBE.6040403@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 24, 2014 at 10:14:06AM -0500, Larry Finger wrote:
> On 03/24/2014 06:34 AM, Adam Lee wrote:
> >Add MSI interrupts support, enable it when msi_support flag is true,
> >also could fallback to pin-based interrupts mode if MSI mode fails.
> >
> >Signed-off-by: Adam Lee <adam.lee@canonical.com>
> 
> Your first patch turns on MSI support unconditionally. That implies that
> there are no harmful effects for attempting to use MSI on a box where it is
> not needed, and/or not implemented. If that is the case, then the
> msi_support bool should be eliminated, your first patch dropped, and this
> one revised appropriately. Driver rtl8723be added this bool, but never uses
> it. Once that driver reaches mainline, a patch can be prepared to remove the
> variable.

Hi, Larry

Just confirmed with RealTek wireless engineer, their policy is:

> Case 1: if the platform supports both MSI and Pin-based, our driver will use MSI.
> Case 2: if the platform supports MSI only, our driver will use MSI.
> Case 3: if the platform supports Pin-Based only, out driver will use Pin-Based.

I think it's safe enough to apply the first "rtlwifi: rtl8188ee: enable
MSI interrupts support" patch also, and the msi_support bool should not
be eliminated(at least for now) in case some wifi modules don't support
MSI well.

Thanks.

-- 
Adam Lee
