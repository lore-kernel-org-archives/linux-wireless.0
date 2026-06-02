Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A40831352B
	for <linux-wireless@vger.kernel.org>; Tue,  2 Jun 2026 20:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780432349; cv=none; b=schSkRYfGDGSrwD0xc0uwgFH7iY4Nu6ruNUT0JDHzhDtsBQ/ycEJG7isKcU6vphQKkcAdRkYyZxgl5xNpiGtH+W2wxgWzdYJMsjV3tiSRyp62DNgSVnyFRCyVUhv+ghxPoP2eJdjYMC8KST0cOanD/D+m9uVs7gvfrwHBJYggf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780432349; c=relaxed/simple;
	bh=D451K68YXi0VVvO2lWp+kSDvSLOugmI2bwM3iQUmO3w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sD5zlg+xpjqvpKV8n1Qi3Hec4Bv6HSLHTKhKdG9i1+BftDJGmfiMLqzqNmziKs8URABFgx/X3fEXDphzrr6e8/yuvEYoY18V6oqdYtHAt8kCkMR+vVe4vdVNf+Y79XLa76JJlAsH5PZ8YhRBJBj9FZwnJNouUOT5i+7x41H6UBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-69de23f28d5so8841294eaf.2
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2026 13:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780432348; x=1781037148;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YL5nMlPraDN24Z7ecvcmfheTXvHmW6igzkP+gzLkuKc=;
        b=rG/ZtV2ze99q+zTBdMTlXpb3icGNzeg1QnVEWYtW0388HEnd/U7jcChIdS8N9jrUvD
         D0McraEOgvYaKmCRqLxUe13VMjbT7oJnMVW3739rtc+Y1NyPVUDEdlq9b6VnWHtlFnui
         1VCJkLCcUmF1UwN8QS9wpA9tpiBkt0TMoyYiCobGYc5Ezmf1RNqGxNYAARhFZ7M47den
         qZfns1Fp94zdlZILAZH0of7z+SfJ9O6vyaqaGTc+D28KPYw8n7UsTbVGbUA3bk/BukAt
         ZjZlU7cPUJGDMrVYVptR5FZ1P5K1sbtSvVT/PVDNhG5VdEUiZ0Hqw0DuLzvB2nnt3CSk
         B7/A==
X-Forwarded-Encrypted: i=1; AFNElJ9wbHpi239yEcFGEYofVoNh2gN0lCCm3IBnreoWtEXld/bBe8Ky1jG2TVtqbhwtdYpzXwd698HkJyYwKiTnNA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfqSiRdZW1RjWeGYj3G3G/mSpljss/2u5iB77A3In0NQNUkdrV
	PD6mCetT9MruJTlxk2To/AE0nbhdZZpEWs6ED6FZqQ1WmYixBj66NIAwKr+fih5QZr87F++w6SU
	93PW8tFnxO3pldHFv1Ea4HS0+6PjblGglP8C2fDfSyJ9iudKCVikufdg4xmc=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4d87:b0:69e:35a5:136e with SMTP id
 006d021491bc7-69e47ecb87cmr326459eaf.24.1780432347870; Tue, 02 Jun 2026
 13:32:27 -0700 (PDT)
Date: Tue, 02 Jun 2026 13:32:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1f3ddb.7b89b7e1.205e57.000b.GAE@google.com>
Subject: [syzbot] Monthly wireless report (Jun 2026)
From: syzbot <syzbot+list14f4c43fd705908896b8@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello wireless maintainers/developers,

This is a 31-day syzbot report for the wireless subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/wireless

During the period, 1 new issues were detected and 1 were fixed.
In total, 31 issues are still open and 176 have already been fixed.
There are also 17 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  6959    Yes   WARNING in __cfg80211_ibss_joined (2)
                   https://syzkaller.appspot.com/bug?extid=7f064ba1704c2466e36d
<2>  1127    Yes   INFO: task hung in reg_process_self_managed_hints
                   https://syzkaller.appspot.com/bug?extid=1f16507d9ec05f64210a
<3>  628     Yes   INFO: task hung in crda_timeout_work (8)
                   https://syzkaller.appspot.com/bug?extid=d41f74db64598e0b5016
<4>  316     Yes   INFO: task hung in ath9k_hif_usb_firmware_cb (3)
                   https://syzkaller.appspot.com/bug?extid=e9b1ff41aa6a7ebf9640
<5>  48      No    WARNING in cfg80211_switch_netns
                   https://syzkaller.appspot.com/bug?extid=3515319a302224e081b4
<6>  39      Yes   WARNING: ODEBUG bug in ieee80211_led_exit (2)
                   https://syzkaller.appspot.com/bug?extid=e84ecca6d1fa09a9b3d9
<7>  38      Yes   KASAN: stack-out-of-bounds Write in carl9170_handle_command_response
                   https://syzkaller.appspot.com/bug?extid=5c1ca6ccaa1215781cac
<8>  34      Yes   INFO: task hung in nl80211_pre_doit (3)
                   https://syzkaller.appspot.com/bug?extid=da14e8c0ada830335981
<9>  19      Yes   WARNING in __cfg80211_bss_update (2)
                   https://syzkaller.appspot.com/bug?extid=1a797e1c81be78a2ace7
<10> 954     Yes   INFO: task hung in reg_check_chans_work (7)
                   https://syzkaller.appspot.com/bug?extid=a2de4763f84f61499210

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
