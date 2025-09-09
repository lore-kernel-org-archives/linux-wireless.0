Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F62EEA6
	for <linux-wireless@vger.kernel.org>; Tue,  9 Sep 2025 04:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757392717; cv=none; b=osY9sM8aQdn8Bhvgq/psGnYzD7UbACgKRs7mNlPZPugWj90YIR0hmxV7V1p5pXy2QiL0szD8IqhxlIU028Q47dBbZ2H6lWbcySWhe8n/fY3ewQZdmFaoYGkyt0PZKQkCo2NpQISFjtV1HugBvIFp3gJ3m/aBD4lUqM5jnaOD7Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757392717; c=relaxed/simple;
	bh=4+56pW9cIBiZJ3uNzSfKYnweW9rKcR5jbzvFHduBPvI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=M7WpH6Poy92/9vxNeqVLVSt7TqHwsCmDza+Ys48o7vbW54BOLHZNFnosgWVvcTzi3dGCfuGdSPhHVkQt4Gtk1jvdjyyUjefyGBPpmS2nGDRcI/hQWKj4qGtt1SPZJPENeoYmPX6Hr80fjEBxAjyFuoFMN49MYvipvtvDXmO2Um4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=vIM0kCrv; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="vIM0kCrv"
DKIM-Signature: a=rsa-sha256; bh=pm8f0z/oYg/qZbfSkc5MmHnJF1AjUGATtr+jSOWpKFE=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1757391802; v=1; x=1757823802;
 b=vIM0kCrv8WXOLF5e3h8I0CbFRcovWuepPbKY6vDXinjOyjCoTCwgC7ChBlYk+rsTtcT/Yjqo
 kT90fxqkIWA1c6gplAH1J16N6XIFUdWMiErEXNvvmB1/H7mloqzLfT/X+j5g3dvBSed6iXfyHZd
 yaPlw9ANzDPupXYX7CPArp4BD8PPWbsmQLv1zc9e0k+6DTFofMlHtM8ycbD6Q4fKS5ZA0jBHvI/
 rGzR8T5VbTevkxXN+4W8J11Ipwpve18rSWRXZrVdL/g4jEoCv+KcFRr73nBrnmFWt4WEc5o/PCo
 5sQ9dOO4Gp65ce7/LrGMtJYZoDfuHtBkzUQrTY1jTtgDQ==
Received: by wiki.archlinuxcn.org (envelope-sender
 <oldherl@archlinuxcn.org>) with ESMTPS id ca7e2d54; Tue, 09 Sep 2025
 12:23:22 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 09 Sep 2025 14:23:21 +1000
From: oldherl@archlinuxcn.org
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Possible Regression of RTL8852BE on linux-firmware-realtek
In-Reply-To: <19ceb132bd1a4382a71caa744ab6505e@realtek.com>
References: <2082485.tdWV9SEqCh@alphecca>
 <c85ca611f0d74d2eb8bc400ebaaadb9b@realtek.com>
 <9ab95a57cffe13bcdfe6ad8b8027e41d@archlinuxcn.org>
 <19ceb132bd1a4382a71caa744ab6505e@realtek.com>
Message-ID: <80ce36ba557f4c030cd80d77c86303a0@archlinuxcn.org>
X-Sender: oldherl@archlinuxcn.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2025-08-29 15:52, Ping-Ke Shih wrote:
> oldherl@archlinuxcn.org <oldherl@archlinuxcn.org> wrote:
>> Sent: Friday, August 29, 2025 1:45 PM
>> On 2025-08-29 15:38, Ping-Ke Shih wrote:
>> > Did you use Bluetooth too? Please try 6.17-rc to see if it can improve.
>> 
>> I do have bluetooth enabled but at that moment no bluetooth devices
>> were connected to the laptop. I will try 6.17-rc later.
> 
> Please also try to disable power save by
>    iw wlan0 set power_save off

Looks like it's fixed in 6.17-rc3. No need to turn off power_save. 
Thanks
