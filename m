Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:24632 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYIZQpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 12:45:19 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1110926rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 09:45:18 -0700 (PDT)
Message-ID: <ef111e7b0809260945p16abde01ud17e19ac2d03fdb5@mail.gmail.com> (sfid-20080926_184536_391731_7C3D15E5)
Date: Fri, 26 Sep 2008 12:45:18 -0400
From: "OB Lutz" <ob.lutz@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Rate control in adhoc mode under ath5k
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to get the PID rate control to work in adhoc mode. The hw
address given to both rate_control_pid_tx_status and
rate_control_pid_get_rate are both FF:FF:FF:FF:FF:FF, and so the
sta_info_get calls constantly fail. I've been able to trace the sk_buf
back to ath5k_tx_processq in drivers/net/wireless/ath5k/base.c but
can't find anywhere that the address data is/isn't being set. Is this
normal behavior for adhoc mode? Adhoc mode is essentially
non-functional under auto rate selection. Forcing bitrates works.
