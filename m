Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:47966 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3EGOZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 10:25:04 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh01.mail.saunalahti.fi (Postfix) with SMTP id A44349003B
	for <linux-wireless@vger.kernel.org>; Tue,  7 May 2013 17:25:03 +0300 (EEST)
Received: from [192.168.100.26] (a88-113-65-16.elisa-laajakaista.fi [88.113.65.16])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 873C369A7E
	for <linux-wireless@vger.kernel.org>; Tue,  7 May 2013 17:25:03 +0300 (EEST)
Message-ID: <1367936622.32148.95.camel@cumari.coelho.fi> (sfid-20130507_162531_953458_9B853443)
Subject: Re: [PATCH v2] wl18xx: FDSP Code RAM Corruption fix
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Date: Tue, 07 May 2013 17:23:42 +0300
In-Reply-To: <1367915409-22082-1-git-send-email-coelho@ti.com>
References: <1367915409-22082-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-07 at 11:30 +0300, Luciano Coelho wrote:
> From: Ido Reis <idor@ti.com>
> 
> In PG2.0 there is an issue where PHY's FDSP Code RAM sometimes gets
> corrupted when exiting from ELP mode. This issue is related to FDSP
> Code RAM clock implementation.
> 
> PG2.1 introduces a HW fix for this issue that requires the driver to
> change the FDSP Code Ram clock settings (mux it to ATGP clock instead
> of its own clock).
> 
> This workaround uses PHY_FPGA_SPARE_1 register and is relevant to WL8
> PG2.1 devices.
> 
> The fix is also backward compatible with older PG2.0 devices where the
> register PHY_FPGA_SPARE_1 is not used and not connected.
> 
> The fix is done in the wl18xx_pre_upload function (must be performed
> before uploading the FW code) and includes the following steps:
> 
> 1. Disable FDSP clock
> 2. Set ATPG clock toward FDSP Code RAM rather than its own clock.
> 3. Re-enable FDSP clock
> 
> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
> Signed-off-by: Ido Reis <idor@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
> 
> This replaces a patch that was part of a series that Arik sent a while
> ago.  Just did some clean-ups and tested with PG2.1.

Applied and pushed.

--
Luca.

