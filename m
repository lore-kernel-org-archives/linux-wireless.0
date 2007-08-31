Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:51092 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965676AbXHaVbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 17:31:33 -0400
Received: by fk-out-0910.google.com with SMTP id z23so701208fkz
        for <linux-wireless@vger.kernel.org>; Fri, 31 Aug 2007 14:31:32 -0700 (PDT)
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 1/6] adm8211: Switch to eeprom_93cx6
Date: Fri, 31 Aug 2007 23:40:52 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200708310055.37580.flamingice@sourmilk.net>
In-Reply-To: <200708310055.37580.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708312340.52730.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +	ADM8211_CSR_WRITE(SPR, reg);
> +	ADM8211_CSR_READ(SPR);		// eeprom_delay
> +}

Is this extra delay needed? eeprom_93cx6 also performs
a ndelay(450) during each pulse

Ivo
