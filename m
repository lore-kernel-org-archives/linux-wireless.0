Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:53866 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaJSLu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2014 07:50:26 -0400
Received: by mail-wg0-f43.google.com with SMTP id m15so3570768wgh.26
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2014 04:50:25 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 19 Oct 2014 17:20:05 +0530
Message-ID: <CABPxzYJXPbmrfrgyoE5X9UO-3LQQVnXYtpz3x1Sd-fhts-Ns-g@mail.gmail.com> (sfid-20141019_135039_580405_D4E0A62A)
Subject: SMPS for AP mode confoguration
To: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are testing SMPS functionality for AP mode. The driver conveys its
capabilities through setting the HT capability which can be set to 0-3.

I wanted to convey support for both Dynamic and Static Powersave
and then control the config through hostapd.conf file. Currently this is
not possible.From driver i can only advertize support for static (or) dynamic
not both (HW_SUPPORTS_* is a different thing which is used in
doing checks at debugfs level).

So if i wanted to configure different modes from hostapd.conf, i
have to change the driver settings as well.

Shouldn't it be the other way around, based on driver's _HW_ flags
we should convey the capabilities to user-space  (currently we use
ht_cap for this) and it will configure the mode from the configuration
file.  I think the design of SMPS configuration should be changed.


-- 
Thanks,
Regards,
Chaitanya T K.
