Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:56639 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbYJ2Q35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 12:29:57 -0400
Received: by nf-out-0910.google.com with SMTP id d3so44515nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 09:28:46 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/5] rt2x00: Optimize configuration handling
Date: Wed, 29 Oct 2008 17:17:57 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200810291716.47342.IvDoorn@gmail.com>
In-Reply-To: <200810291716.47342.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810291717.57687.IvDoorn@gmail.com> (sfid-20081029_173002_413909_214DA321)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement latest changed from mac80211 configuration
handling to optmize configuration handling in rt2x00.

 * Remove set_retry_limit callback function, handled
   through config()
 * Move config_antenna to its own callback function,
   it isn't handled by mac80211 anymore
 * Use IEEE80211_CONF_CHANGED_* flags and remove manual
   checks
 * Removed deprecated short slot setting through config()
   and put it in config_erp() through which mac80211 now
   configures it
 * Remove config_phymode() and move contents to config_erp()
   since it only managed the basic rates which is now
   determined by mac80211 through config_erp().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
Patch has a size of 52Kb, it can be found here:
http://www.kernel.org/pub/linux/kernel/people/ivd/patches/0001-rt2x00-Optimize-configuration-handling.patch
