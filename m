Received: from mail.kapsi.fi (mail-auth.kapsi.fi [91.232.154.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D868732C925
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2026 12:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.232.154.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769775523; cv=none; b=IsE1XGcwFuX5p5AnCo9W0NZMzhh7KbUZh+RqkvYusG/7CRjENgDTydCbBSZmkEkv4hKRiGedfFp0oXdhEsgEpx6Zl7xa5Au8pVTSNEwwNp7BI0cGUKMust/BF5QuC4CYzs2FwWXX/PrikwJFlOr2PQrKCNBKRi8mtuAGPo9qn5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769775523; c=relaxed/simple;
	bh=WMQYC2ECElU+Yo72RuzWdoSlpVJpi22L1B5urUcreuI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=thRIv3DjCaPfHxYjWAfLeHLi1dpWaSnCW0UWAE7A/UNt6ikaoM+VNZpAGXB6RnlQOa2d46EcuoHZJxmWNO9UU5lO2KNgS6/uicvR2MqA5vDx5bY8aLxN8sjRPkMupVPB5qblJ+cTweO68uVlQmb9HSHsoTiMZnm1YgETDyHu6bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mail.hopiavuori.net; spf=pass smtp.mailfrom=kapsi.fi; dkim=pass (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b=QjDv4GZf; arc=none smtp.client-ip=91.232.154.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mail.hopiavuori.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kapsi.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="QjDv4GZf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
	s=20161220; h=Content-Transfer-Encoding:Content-Type:Subject:From:Cc:To:
	MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EQIITpPRApet7+SQPGzxWI2DjJmP0PMYqzH0v5ZTA10=; b=QjDv4GZfQj7J4J84McOeuFhmj8
	Cg9DOlA8wovTacha/sX8cvlWrgImjJoWQvuavqA4tYWlA7NnzSGwxOXjqs+SKLXhNY9mW0qrO69fI
	6jw/MvDRxuae9bicOgLwmhhugZWg37klBMtdA2H08LJvp0BTQLu24jgswTpspoIjB2dlwdhmlrxEe
	BrsD9YpvtKlc2KsEeDszUfzyXYojE0HcMFAxLYBeT03426kXTmmtXLjXd6aE7rYBPGTKUYt0aLI6g
	JsvnOiMy+IRXb1XNNgGUSvCV2fk/dQljCWKYPg6wkxjBaMCCDA47Anp9k1Z9QTPQ92PANkO6nWvS/
	BgHVnmiA==;
Received: from dsl-hkibng41-567305-225.dhcp.inet.fi ([86.115.5.225] helo=[10.0.100.21])
	by mail.kapsi.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <linux-wireless-mailing-list@mail.hopiavuori.net>)
	id 1vlnSM-00AE2t-2y;
	Fri, 30 Jan 2026 14:18:34 +0200
Message-ID: <89e415cf-246f-41aa-942e-132be83df632@mail.hopiavuori.net>
Date: Fri, 30 Jan 2026 14:18:34 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list@broadcom.com
From: Utu Hopiavuori <linux-wireless-mailing-list@mail.hopiavuori.net>
Subject: brcmfmac: iwd fails to connect on multi-AP networks (MacBook Pro
 12,1, BCM43602)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 86.115.5.225
X-SA-Exim-Mail-From: linux-wireless-mailing-list@mail.hopiavuori.net
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false

On MacBook Pro 12,1 with BCM43602, iwd 3.8 fails to connect to a network 
with multiple APs under the same SSID (connect-failed, status: 16). 
Non-free firmware loads successfully; no NetworkManager installed. 
Workaround using wpa_supplicant works. Applying options brcmfmac 
feature_disable=0x82000 allows reliable connection.

Debug/logs:
* 
https://p.kapsi.fi/?955065d6c0d0caf1#D8NZwkNPxayrNRWHxR8UofT3htVDRw64nu5SG41v3BvS
* 
https://p.kapsi.fi/?58aefcff5920f733#F4MdmgRbmTUtgsbVm76ixMRwFktkZMJEuwCW9ZLQMNJo
     - Boot 7db8fc4051a14fba8c19086100bf2f0d: before fix
     - Boot 2bf8b79cf80c4abb95b2ad8c074a4249: after fix
     - Boot 402b96dbfcc44b5c9d31bf5f15af8bf5: always known-good-network

--
Utu Hopiavuori

