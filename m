Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAD61E98EF
	for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2026 22:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776896390; cv=none; b=eBaKqNSDE5Q4aqkwBNoXOQjrz1iSmVZzqfHOpIYHsE6gmWE910K9jSREwXtDzBp6wjrM8CL89FYRFTrUiyYkzG4Bwc+nhrjQoCWBAI/7qqzXscuaWDDsJjhrNkqAsyfO3R60eoyLZMO2j4TOJFET9gWgsMLM+FMQ80v23qKdLp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776896390; c=relaxed/simple;
	bh=9nCNK53rTjLnVysfgXoglxvrQ8+xq11LiIZcoNznmu8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=BHCzc0weinZuJrUqWFeoIMD/nDyvE7O3M7tKbKTKobKKQ1YjcAB2QS5geN3B3LNrKrXMTszxndB2xrt5QYLSTzOkJBMhpNu66PB+LHpoTvcOnEJoapOfppRqKfX8tWZCDTFyW3nkAvd/QcNLJlLV248LnvgMtznLcV/yJUUa5CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=FmiGCaCq; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FmiGCaCq"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6763cc8775cso5599075a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2026 15:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1776896388; x=1777501188; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9nCNK53rTjLnVysfgXoglxvrQ8+xq11LiIZcoNznmu8=;
        b=FmiGCaCqbdUMI2cf0zyy6ct/eRTUf01S7Gd+62v/euZy0LTNQdbyh0wFbad/gQG/4V
         zUsPkzW4y/ZLBr99/+SKMddsYxh9Je5HYtBBWL9244m7q6AKxAYfWH6gb4+x1PavnNpO
         qTgR9fVmQbT2EIHPmcrR9bZ6TJjWSi7xb5xFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776896388; x=1777501188;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9nCNK53rTjLnVysfgXoglxvrQ8+xq11LiIZcoNznmu8=;
        b=AN8K/GJfdLNVjnKQsiB/rj0S/3hc+U1Im0Bm47hfoLwkXoCysaf/uNK4fZjynrrYVl
         HXynr5mr+b3raeNwjAWhUuNc+L1T4Rl9/IGG2NJV8mKoXaq2teODSraDMDZHPaZ6JWAr
         4Yn4yrAkzSctNltDAOyaK5ZY02i2wsYRpcLO+6K8y0CFuGc/yDIdtykGl52jwJUz/ByG
         fFnhoAaq2gaNkCiAI+/zyTZFNRazEPf98Sfqki+67zuFYnoXJTt3+dHyajdVk43BKZUf
         OJQcMFbVjTGvEUCPH8T0SGGajygPB+TAWqZzGBI69jZ3txylAREif8MQGC/c29T8YgRk
         eGMg==
X-Forwarded-Encrypted: i=1; AFNElJ9tu3ytND2wBM/GTySR2cZqV4GRNsXwM0xIxJR3TJ0ROzmGxc7IU7gaPBTxY0P7qV0kAs7wtjj2zLfl32KZMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPz2QlOjGtqJCHRNr0cV/Uh+DpnArZ7laUjuglhFQh6OgA+GLm
	iPQ7xsMlv4e07iB51iEX1jXlvc2JRoogMwUTrebaIUrlfVCC3g/7ykSHv0z2Nz3Z+s4wpMcbthn
	kH5l1rQzh
X-Gm-Gg: AeBDievlWNPxTWHqzIGXDLyFUIIFl3aEUb4TtwDVVP965oyeC1iyuIHApxGpzTk2ap9
	YJrzf+0A/K9Ggbuw6uZGdvtEYz6u4Qqwx1gbao4ktHzdFERHu/Fqs17npvCT3vHi1XlBn3qSc/x
	czrElwvUeKNTU6Oy698ofEEdH3gMPZxEEfgX33po8IDWhoanrfBLYvcxZHIFprbn0bjsDigOTFK
	kRyzcOS1dJAOa3PsbCqP//y3qoFZrCppO7JXpg9PBOvsGCP1B1UusVR3sdfArnWZ1ira17veF9E
	pVBjmnOSe7YxSFr+6M9B7x9HrxW3r6VVoK6Q6Z5NMWiOAZZG077Xavwg8IDLy4fvY93qMXmIgke
	zei7CfZ98U9T3dWljJRsnfvhwyfq9HgPu8KobGkw2LYbyM8rFHNUDbBqrDSl5xL+luWOy6FocMj
	q1sRvMp1HtT3KWGc20IugmnNsj+TvnpKbSBRfD1TvWhQOf9bsH+Hx+GaNGvXY4W7UE2ijr
X-Received: by 2002:a17:907:e2d9:b0:ba4:75c3:5024 with SMTP id a640c23a62f3a-ba475c35298mr964182666b.20.1776896387710;
        Wed, 22 Apr 2026 15:19:47 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba451210e3dsm598217466b.2.2026.04.22.15.19.46
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 15:19:47 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso62101985e9.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2026 15:19:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+xgGvxVpm6vI3R3thjXowVYTMcYz8T6onLyvOE3IJZ7h+cnfHQvQHZygy8E5nAmpC96YxirFa+N3oVx7VbOw==@vger.kernel.org
X-Received: by 2002:a05:600c:1988:b0:489:1e5e:2cc with SMTP id
 5b1f17b1804b1-4891e6d485cmr202233445e9.9.1776896386155; Wed, 22 Apr 2026
 15:19:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: David Ruth <druth@chromium.org>
Date: Wed, 22 Apr 2026 18:19:08 -0400
X-Gmail-Original-Message-ID: <CAKHmtrRD35fnE_TsZHzfgQ5p7=WHE1Fz8wnV0t2SGxDcgmopjQ@mail.gmail.com>
X-Gm-Features: AQROBzBmd__SQ8rWjwodBKJTNSgO5yk1P_pxzbFRSNYWLXnIWe4Cen5zLFr9bzs
Message-ID: <CAKHmtrRD35fnE_TsZHzfgQ5p7=WHE1Fz8wnV0t2SGxDcgmopjQ@mail.gmail.com>
Subject: Re: [PATCH] linux-firmware: update firmware for MT7925 WiFi device
To: jb.tsai@mediatek.com
Cc: Leon Yen <Leon.Yen@mediatek.com>, ben@decadent.org.uk, 
	=?UTF-8?B?Q2hyaXMgTHUgKOmZuOeomuazkyk=?= <chris.lu@mediatek.com>, 
	dwmw2@infradead.org, jwboyer@kernel.org, linux-firmware@kernel.org, 
	linux-kernel@vger.kernel.org, 
	linux-mediatek <linux-mediatek@lists.infradead.org>, 
	linux-wireless <linux-wireless@vger.kernel.org>, litien.chang@mediatek.com, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Felix Fietkau <nbd@nbd.name>, Quan Zhou <quan.zhou@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"

Tested-by: David Ruth <druth@chromium.org>
