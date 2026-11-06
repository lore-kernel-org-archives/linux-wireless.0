Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793939637;
	b=P6O5sj/QszwICMz1ypL12zaCiExjwrhTCnAT2aQ03wrnf3J58JSIJZyHSyaNMBTun5hN
	 gfYQsuHGqbV0qlAtknolaL4lNKfif3LnFmBxY+5ZNbj4l+uoss6ixmFzutvTheASNOKYj
	 vIX1e3Kew/6rUHRjA+MER6BeSIfD4672uuZDMwckaGy0As8agwZufzzjxheEs7ABDqlpg
	 ZVh/o8l3zwR+RsmBxlTvS/w5iJcmXgaWf0P3+t0qwNZJS9JMDOKc/T64kT5svpdoXmOSI
	 fdQUaFAo3wgOVMzAywtGqtQ3n1CiI9oPwV8BrBqYD9tG7PWMXlo0jIgS5rN6i/LAkgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793939637;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=UjmvlMxMfsOJ2MipGoWSWM8HIKzXWVlbjvE93f4mWOI=;
	b=d8+Hw4JZuS5VIu+SARiK9+5UTgvxZmm92DuCdyiRLbGBaMnpJiAI6oRidp3+mcXh4VPF
	 CVduPhBun1XKEgmRVZqWGMZtsSLFaRwjW5dYFYpXuqfi+wsAn7QKQIi2Qxp3kvY1XMcC5
	 oo3xOB7SLSlYs1yx6dd6ONKlSDYeeg5FC37Wj6yzrohtFK3KTsYonfZgZILlf2tWYGJoG
	 8umrnudP54TkZ0vnkEzPfQRKbWkQVbKu+EOdnGcdazmMVp9qzhILnya4hJBw4dAllnInk
	 A97+saFb3tq4N0rZ/XOcJkacna84TfucJZRn0D4+0Zf79DbCKEFVTCD7bthVpZWBn9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C09606D811
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 04:33:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1C09606D811
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-54dbbf252cdso282195b6e.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 20:33:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793939631; x=1794544431;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UjmvlMxMfsOJ2MipGoWSWM8HIKzXWVlbjvE93f4mWOI=;
        b=m9oDKQi2jCK9qjC2uwTiWg7ibp8GSE2uOL7f2Yy87ZgDukvA5FM5dtQ4jl6PI9nChT
         x4fseCoAOh3kbWddQntk8p1qKkHwCAd4bMxC1vtLmHMTnx0Yf7A0qeH1b6jdRkUr+37q
         2V1liisqrhh/jcTPZBkzJRyUsAwLKiblECBSuzkrMtFm1BqwmwwLJqoe2/qQeZ43rKqt
         4G0Us1+flr1KGgkh/Gn4VoE4u6/VBZ8NpUXecGEoMRWlsEJ5zGWA+aHjM1Rj6hOaISZX
         T5D2vqqBVNjhcX/ujthwAnGigRPPdrOj/vVIby0NE7zYiUVMvjTR/rh4OxF6syA65Bdb
         I67Q==
X-Forwarded-Encrypted: i=1; AKwUvBxQiKIo8Yv7OcOtjoS2yAThTvjc4FZTlo2trEgllWRMLY3dbw4lrWC6DeAq3u/TRjG9E+HLTmd921qp9fcJJg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9HLjs+ZMWqxUo8ul7DpauTaytrlBTO6tueWFOqVrdUtUF8LwSH
	+E2rrXOTLRE6gLRQ1OYMvaSo3T8B+WaCuSlife+wVHWbclQOcq4t26MHtvgh9eGtdtu7zaIO9la
	C/Uom3dS7hN0JWQNgIRHyoQdcAm+kYusixj40yMRqUiJMWbJr6FVEfazj568=
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1828:b0:4dd:18c7:5448 with SMTP id
 5614622812f47-567e16d6313mr1093975b6e.56.1793939631120; Thu, 05 Nov 2026
 20:33:51 -0800 (PST)
Date: Thu, 05 Nov 2026 20:33:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aed58af.02d3f859.2829d1.0007.GAE@google.com>
Subject: [syzbot] Monthly wireless report (Nov 2026)
From: syzbot <syzbot+listd640a374c372365da528@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello wireless maintainers/developers,

This is a 31-day syzbot report for the wireless subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/wireless

During the period, 2 new issues were detected and 1 were fixed.
In total, 16 issues are still open and 219 have already been fixed.
There are also 7 low-priority issues.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2134    Yes   INFO: task hung in reg_process_self_managed_hints
                  https://syzkaller.appspot.com/bug?extid=1f16507d9ec05f64210a
<2> 1236    Yes   INFO: task hung in crda_timeout_work (8)
                  https://syzkaller.appspot.com/bug?extid=d41f74db64598e0b5016
<3> 365     Yes   INFO: task hung in ath9k_hif_usb_firmware_cb (3)
                  https://syzkaller.appspot.com/bug?extid=e9b1ff41aa6a7ebf9640
<4> 63      Yes   INFO: task hung in nl80211_pre_doit (3)
                  https://syzkaller.appspot.com/bug?extid=da14e8c0ada830335981
<5> 24      No    BUG: workqueue lockup in reg_todo
                  https://syzkaller.appspot.com/bug?extid=b733a65a200ab7aa2cbe
<6> 22      Yes   INFO: task hung in cfg80211_event_work (4)
                  https://syzkaller.appspot.com/bug?extid=5506b2556159a1ab6923
<7> 103     Yes   INFO: rcu detected stall in cfg80211_wiphy_work (2)
                  https://syzkaller.appspot.com/bug?extid=858514d213c2ff9b671e
<8> 4       Yes   INFO: task hung in wiphy_register (2)
                  https://syzkaller.appspot.com/bug?extid=e79f3349c93df8969402
<9> 4       No    WARNING in cfg80211_cac_event
                  https://syzkaller.appspot.com/bug?extid=3df76a08d929e91e5327

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
