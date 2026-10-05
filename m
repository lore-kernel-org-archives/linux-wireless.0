Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81E0395AFB
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791232422; cv=none; b=Wwyo/+WTTyRN5vCKXDiBFOA8t2Sa4CFSDpcBJ7tGbpZeZ8o6pD+Aqe8PIV/zmw+nqrmWVfzw4RNt6VDX04F/Mxawohug24rWNvG27eZ90DwDEbV6qPmbe9rdb5QZdJm5CTAOcjge7mzjGQakQ3t2Bs7V162lFBky0LDW/nrk8ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791232422; c=relaxed/simple;
	bh=W7ZgDV85XzKosR4KK6b9llQ1ZXpNjEupVAHB9XWhs4g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=u9VReLQif5tuGjcXLqqEtAGoSEV7f4CoCmaV/CWHrw4ppdhAzc+811j9A9Av7nOd67wQYvIdWruZKYpe40R+wwCbAjhqte+ZExAIL+sLFYmf8I5OZundvgH71fyh5Lto3gFjNTpbXTpp6UfpE66BfzXgqJllQga6jrudPOEEU+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a45b3f0bdfso3292459b6e.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 13:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791232418; x=1791837218;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yzbD9+nTxp47Myo0E+kEg48QK+FPm0GwCR6nWvaHwew=;
        b=aNV7OhgNYDQL6MtQ1RgFtvVyQxuHBkOAzhnLqzydWq1Lbn+zlqP1Bd8qFgRUai7KsT
         gwQ2BR3w+xo8ALd5ZHw3VKBOCUInPz6tJyCRA6IsoUIvUxcsSMGc4hNxqFzNmeInm5V6
         NmTLZVjTVlidSmLDCdw9uz7fkveulkJFuW6dUDoNX7ybZfspGXc3f3t+r565G+y40iy5
         WA8lrcROXXVaG9LsM7frW/Oe7kgttCHhNHxNZtJpnHLG/MaOnG4RGsQzFdV+rQKft/L4
         7KtLuhDqa5pzAkwcrc/pdoLibF2MQriYbQwu7aovPHHdUoxYkUMIa+xagAjStv3FN5gv
         rwMQ==
X-Forwarded-Encrypted: i=1; AKwUvBzb1sCyvlW5s2aHR3BrdMS+9HGkXYKsi8JW4NqZt90uvkJ6n7jOxZcqazB8xxVXHZFS+kER2OGwnrhc1gBWFg==@vger.kernel.org
X-Gm-Message-State: AFuF++m0EuJytvFgtkUfbJl9jTDIIyxGm9ww2u8I7Pmg11R0eAVp40yA
	WqsEUS7Oc1fdFvCx+EN/nqnaitWei+JJe7TMXIHLtc2H3cX8B/mjWE8ltTGq94Wxl/3zIbU6eP1
	RIiZ2AmX9VK8NbU6F8TJudCswqEPuM8UE6Vc+u38JVNt5n7lbYRugU5/+Fko=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1815:b0:4d6:9335:d533 with SMTP id
 5614622812f47-4f67bb6e875mr9355855b6e.64.1791232417839; Mon, 05 Oct 2026
 13:33:37 -0700 (PDT)
Date: Mon, 05 Oct 2026 13:33:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac409a1.ae2c267a.265a6c.0009.GAE@google.com>
Subject: [syzbot] Monthly wireless report (Oct 2026)
From: syzbot <syzbot+list7f43769dfd404e5bafc6@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello wireless maintainers/developers,

This is a 31-day syzbot report for the wireless subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/wireless

During the period, 2 new issues were detected and 10 were fixed.
In total, 18 issues are still open and 215 have already been fixed.
There are also 6 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  1670    Yes   INFO: task hung in reg_process_self_managed_hints
                   https://syzkaller.appspot.com/bug?extid=1f16507d9ec05f64210a
<2>  1007    No    INFO: task hung in netdev_run_todo (4)
                   https://syzkaller.appspot.com/bug?extid=894cca71fa925aabfdb2
<3>  998     Yes   INFO: task hung in crda_timeout_work (8)
                   https://syzkaller.appspot.com/bug?extid=d41f74db64598e0b5016
<4>  360     Yes   INFO: task hung in ath9k_hif_usb_firmware_cb (3)
                   https://syzkaller.appspot.com/bug?extid=e9b1ff41aa6a7ebf9640
<5>  55      Yes   INFO: task hung in nl80211_pre_doit (3)
                   https://syzkaller.appspot.com/bug?extid=da14e8c0ada830335981
<6>  19      Yes   INFO: task hung in cfg80211_event_work (4)
                   https://syzkaller.appspot.com/bug?extid=5506b2556159a1ab6923
<7>  8       No    BUG: workqueue lockup in reg_todo
                   https://syzkaller.appspot.com/bug?extid=b733a65a200ab7aa2cbe
<8>  6       Yes   WARNING in __carl9170_tx_process_status
                   https://syzkaller.appspot.com/bug?extid=381102a7292a374fe8a7
<9>  1879    Yes   INFO: task hung in reg_check_chans_work (7)
                   https://syzkaller.appspot.com/bug?extid=a2de4763f84f61499210
<10> 140     Yes   INFO: task hung in regdb_fw_cb (2)
                   https://syzkaller.appspot.com/bug?extid=aff8125319e0457b4a25

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
