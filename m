Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792647096;
	b=DWY+joSwo6bC+jUqb7CAwH686y/69XF7f/iKnb8opt97qJRPVEhmrp/UUXIbcNTs42XM
	 LRl0jVVPkYk6tPbx63ePUC4GDOVP/A6TiwDjXzeruFOPNro3HcALGOyrCfssSb4YjC0jJ
	 emvC5akjljMtwpMkFj6j//M62LBxJ8Ka6oe9wIulUj3wjDUKR9q0BF+aEVOQ2++Woequo
	 O1Ezb4859fdgONDXWLCp1dMgPFV/uCezVBcc2SN6D3pOAiDU/So/8gyK6aQNXTi4AjjgE
	 +hIOWS9PeHoucqytcYXgqr/qUccruRHYiVL1yiNjLuGvx63HEchWEVkAV3f2BguTgUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792647096;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:MIME-Version:X-Received:Reply-To:Message-ID:Date:
	 Subject:From:To:Content-Type:Content-Transfer-Encoding;
	bh=YLSVMKJFUU4S+ENkGvQUYpl6uZWfyjjW4Kw7H0GllHM=;
	b=cG1gpbItyfWksq24rdbE7mqpvdpHoyx33BwlA0oW8+at87/7xSpLqM26Kfzx22Kd4Vid
	 vKfFcN4iuGPPbSuux+/bawc9c5X5ju7NQprksM0eNN7ODRnQcygjTYUp5Bttn0Z/MGuU8
	 yRNAykkUDrLUorBFBLSHWfOY9rwqaGYkzpg2SO+9RpoTVOkPoVgg9XRyUPYaIludx1DHE
	 vyz1QeigNJpnJa2bjqT1x/ZgrCYIdgX7F0rwVR0PpHBWABOfcyDWmuAHZj+L/GM5ZkEjQ
	 nKHyE9u8PNwKFqyzSGVYyd9dH/sVq5fnWP/hnGLtrAWqbWd8c7dK4pNUztB/MskpfhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="ZG/oBOSY";
	arc=none smtp.remote-ip=209.85.128.197
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0DB606A31B
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 05:31:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A0DB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZG/oBOSY
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-8b12b209c4dso16950287b3.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 22:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792647095; x=1793251895; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:from:subject:date
         :message-id:reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YLSVMKJFUU4S+ENkGvQUYpl6uZWfyjjW4Kw7H0GllHM=;
        b=ZG/oBOSY6TWt7qwZ0ZQDiwdm3R60l+5ex/DxOfip4HiGSwoV1gZSE/HEZkG5eLBndN
         NoQ0NEqM73ng1mCPCfKgtNntNXy7iAw7hW2eV9WctJTrYkvHX/FrheZ8/S2EyYWESWEf
         C1qaTc9urr7u0hLXlS7qSYPXWVNcNqdv+QY6wwuAUHx/4Ywj+uOORsZoUzzKCYeO60dR
         vEvq2lpeyf+YPGGqK0kSz/mXZDb4uNuRC+WbWNIdyaFuwJWl0ZbffLxzBxU1b7LV+cCR
         VZ+7HCIu95uWl3axsfy6I3omBXz7dgiCcSmQCyK+UM56CPuxYUvIJr+Ord4Zbt329UBp
         lFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792647095; x=1793251895;
        h=content-transfer-encoding:content-type:to:from:subject:date
         :message-id:reply-to:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YLSVMKJFUU4S+ENkGvQUYpl6uZWfyjjW4Kw7H0GllHM=;
        b=T+XQQdSRsHd14VgqiVPhA14xOt9kS9yAzwLtsB5WXFV6w35xBGrcVJwysoe1cuqh7W
         W7Msptdrq74EAHsBVdy0Zz/ts6qVYAfLS9ByzPQE6v4x8LalwrB15e2LV4/zoXy916qU
         IxtOZT00qu1zEGK5/4Siqv88u0ksitZzQuOjfnd6Ry1b96HGJ0GKSk61NFDsPpjhP5Se
         8XYDsnRB4p0k7auDt7NrOrYtfu1mLfrU1KG88akYmyzHjk/pN73qQdGVwrZGXaUMJWh7
         H6vCKlFIWgivLQYnR3NRJzk85xKYH2YEhfj18aaochqjbwvQ5XeiItrYagsH3s3V7idd
         qpWw==
X-Gm-Message-State: AFq9FYKqk/eu8gmigD1k+/2i9CHGevs5uxMVorKHB0CE95r666NV39e+
	KDn6+1fwGqU3aC4nDkxMdvPVOuDzX11a8EolKTydfCYJap4h3yA73v9r5j7YpUYYBexqqxqYQhC
	hiF8=
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:690c:e1d1:20b0:8af:4ecb:b712 with SMTP id
 00721157ae682-8b134013a97mr18574597b3.36.1792647095080; Wed, 21 Oct 2026
 22:31:35 -0700 (PDT)
Reply-To: editorjbift@gmail.com
Message-ID: <autogen-java-2fb0ed8d-4df0-4f95-ad41-2c6ee40faa50@google.com>
Date: Thu, 22 Oct 2026 05:31:35 +0000
Subject: Research publication information
From: krishnasinghjig12@gmail.com
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64

RGVhciBSZXNlYXJjaGVyLA0KDQogIElmIHlvdSBoYXZlIGEgcmVzZWFyY2ggcGFwZXIsIG1hbnVz
Y3JpcHQsIG9yIHRoZXNpcyBhcHByb2FjaGluZyAgDQpjb21wbGV0aW9uLCB5b3UgbWF5IHdpc2gg
dG8gcmV2aWV3IHRoZSBKb3VybmFsIG9mIEJlaWppbmcgSW5zdGl0dXRlIG9mICANCkZhc2hpb24g
VGVjaG5vbG9neSAoTmF0dXJhbCBTY2llbmNlIEVkaXRpb24pLiBUaGUgam91cm5hbCBpcyBTY29w
dXMgaW5kZXhlZCAgDQphbmQgYWNjZXB0cyBtdWx0aWRpc2NpcGxpbmFyeSBzY29wZSBpbiBhbGwg
c3ViamVjdCBhcmVhcy4gSm91cm5hbCAgDQppbmZvcm1hdGlvbiBhbmQgc3VibWlzc2lvbiBkZXRh
aWxzIGNhbiBiZSBmb3VuZCBoZXJlOiBodHRwczovL2JqZnp4eXhiLmNuLw0KDQogIFdvdWxkIHlv
dSBsaWtlIHRvIHRha2UgYSBxdWljayBsb29rPw0KDQogIFJlZ2FyZHMsDQogIEpvdXJuYWwgVGVh
bQ0KICBSZXBseSDigJxTdG9w4oCdIHRvIHVuc3Vic2NyaWJlLg0K
