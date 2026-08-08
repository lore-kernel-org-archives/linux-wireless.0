Received: from smtp.smtpout.orange.fr (smtp-70.smtpout.orange.fr [80.12.242.70])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29902264C0;
	Sat,  8 Aug 2026 20:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786221175; cv=none; b=llILlqyIbGPE/3tktEhIu9qm3nHhqlMakQAGV6bCPFgY+j2tq7uzlKSFGeBCF0Iifm/A1uOkTdDiXSJKvYmwPELHruOzRfFhbhm7OEESDxj+2jt6uUAG+6nFwRU3KwwDU0ZT36zu1fkk3ml+sr3W7dCJ/g58lGKIbGpg6hHwJpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786221175; c=relaxed/simple;
	bh=LYWcp6Pq+RIbyaNzk+cvWEn1TE/RKKoUPiE7s5NIUz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FALWmT1Th3z8fFv1Lzgh9nb2uF77N49zdbsh2OqCVOz05QUPLs6/rR37IWDVCOfbnc99pSkKcD25J+4L0wmylE0meNImDpkC3izNNAqZMvZiERbDXe8GGpr+GuLMGZ+dC1IowWGbVJqsAiSA4EcFfrldcm2sZ1litV64ZpBcE/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=EX375Ovk; arc=none smtp.client-ip=80.12.242.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="EX375Ovk"
Received: from device-101.home ([10.65.86.54])
	by smtp.orange.fr with ESMTP
	id snhlwNvG5Y2ExsnhlwnbqV; Sat, 08 Aug 2026 22:31:41 +0200
Received: from device-101.home ([IPv6:2a01:cb10:785:b00:6128:9b8c:c203:905])
	by smtp.orange.fr with ESMTPSA
	id snhbwzg2ky7BTsnhbw6zVF; Sat, 08 Aug 2026 22:31:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1786221093;
	bh=zg3VPxHZ2neCZ31eTjCUidWOS2M1FLzevXo8PiJKU8k=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=EX375OvkUMZCDnaFa5pDqHz5q5IeQM3F7u8zoeKV6Nl2PPukihMXK8mlMiRGJKRqC
	 NB/bvIC9sFlhbGlZd+fP1xOT//xZ6RBfPIQucJBCtOCF0/QDDASuCu5OTkEpmGqjd4
	 Mo5CL/lf8M93jNXlGYYAQYvQzIRxIsSC8VZFp1Z2/a4cFcA1jnElFpihB0WKENOuEd
	 gymOJpUnxt++GfFGq6IvI9+tPrXGyxQPEB0t7Pyd9u8SnTp14ZKn4Rhvpx+yFDSF24
	 DPbEi/hS+tIopFjCsBZAcCUTyN2smBF5Gt5O7ZhZFDTwxy3elpKa1+7OzjHRMbFVCV
	 du1im85MzfB+w==
X-ME-Helo: device-101.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 08 Aug 2026 22:31:32 +0200
X-ME-IP: 2a01:cb10:785:b00:6128:9b8c:c203:905
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: iwlwifi: Constify struct thermal_zone_device_ops
Date: Sat,  8 Aug 2026 22:31:29 +0200
Message-ID: <a8e9ce13554fdc9d3630e550280209e7e9fed9f0.1786221064.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct thermal_zone_device_ops' is not modified in these drivers.

Constifying this structure moves some data to a read-only section, so
increases overall security, especially when the structure holds some
function pointers.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  32535	   8657	    192	  41384	   a1a8	drivers/net/wireless/intel/iwlwifi/mvm/tt.o
  15212	   2872	    128	  18212	   4724	drivers/net/wireless/intel/iwlwifi/mld/thermal.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  32663	   8529	    192	  41384	   a1a8	drivers/net/wireless/intel/iwlwifi/mvm/tt.o
  15340	   2744	    128	  18212	   4724	drivers/net/wireless/intel/iwlwifi/mld/thermal.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.
---
 drivers/net/wireless/intel/iwlwifi/mld/thermal.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/thermal.c b/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
index e445b1d7d4b0..25c99899c8a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
@@ -234,7 +234,7 @@ static int iwl_mld_tzone_set_trip_temp(struct thermal_zone_device *device,
 	return ret;
 }
 
-static  struct thermal_zone_device_ops tzone_ops = {
+static const struct thermal_zone_device_ops tzone_ops = {
 	.get_temp = iwl_mld_tzone_get_temp,
 	.set_trip_temp = iwl_mld_tzone_set_trip_temp,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 53bab21ebae2..6db141c2cd45 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -643,7 +643,7 @@ static int iwl_mvm_tzone_set_trip_temp(struct thermal_zone_device *device,
 	return iwl_mvm_send_temp_report_ths_cmd(mvm);
 }
 
-static  struct thermal_zone_device_ops tzone_ops = {
+static const struct thermal_zone_device_ops tzone_ops = {
 	.get_temp = iwl_mvm_tzone_get_temp,
 	.set_trip_temp = iwl_mvm_tzone_set_trip_temp,
 };
-- 
2.55.0

