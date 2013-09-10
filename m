Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:42040 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3IJGqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 02:46:51 -0400
Message-ID: <1378795636.4799.44.camel@porter.coelho.fi> (sfid-20130910_084654_752641_6DA18460)
Subject: Re: [PATCH 06/12] wlcore: send EAPOL frames with voice priority
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Sep 2013 09:47:16 +0300
In-Reply-To: <1378218848-7853-6-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-6-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
> From: Igal Chernobelsky <igalc@ti.com>
> 
> Send EAPOL frames with voice priority by setting TX_HW_ATTR_EAPOL_FRAME
> new bit in tx attribute. Sending EAPOL with voice priority fixes
> re-key timeout during heavy traffic issue.
> 
> Signed-off-by: Igal Chernobelsky <igalc@ti.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

This seems to be the same problem that Ben had and debugged by himself
[1].  Fixing this in hostapd/wpa_supplicant seems more appropriate?

This patch seems to take an advantage of some sort of hack in the
firmware that will change the priority by itself when the
TX_HW_ATTR_EAPOL_GRAME bit is set.  If we have a good reason to use this
patch, we need to take care of the firmware version as well.  This
probably doesn't work with the latest published firmware.

[1] http://mid.gmane.org/522E18E5.1020503@candelatech.com

--
Cheers,
Luca.

