Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751EF34D926
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 12:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785846749; cv=none; b=sPiQQ2kQE8C/Q/UXrC+FM4SQdW+gRyM1ZgaU23NK+OQv2eKgUl7Smr/rXLwI44PcR8ouXoICiYJiq0NUFrQojz8+DiAT6S88kLXBAdvlWHv+hvDG4LcIlM5yQU75mg5T7Bam3RnZN19Dfa8n1UArvkTQBR1PTOI7ou+tqy8LX9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785846749; c=relaxed/simple;
	bh=0D5a0u0f7Y4dFB34RWbzvSvHBjtflYki5ROXPXVtABg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BM8JjCX2B5KoRmgMukt5/ARhequCd1CJkmTJGVbAo92T/4X4eT+L4Y1V+jeVTV21g7VWFeAxhJfXxl+rhygRrU1zodCoMJJi8ygb3o6Hi3iy7L6H43Vy8p4llAmJ2WOpMM3MVccklFajnSa/pJ5LZmRIBufL7hixYLPgrxDcmDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a7c64fbbc6so2746129b6e.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 05:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785846745; x=1786451545;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3DsIc6jWq13xbd1BLvPvntwUHcJqAA0WeSMpG9Go3f8=;
        b=WrJSS17siQmdu1oG4K6o7lwro68LVvy5IhTK0lWkcnWuw95Iu3CqQJQ1eRacQgsjCx
         ZrCQVo9vOdhLLwab3/E/OHK1i9dCSYYwTFtX/OrWzDnMZkuckr/RVxjZyYz11a0Ic2hY
         H5TKhKfAWJy927JxasH6QU6UP3foEpkdEjpH/GUGvnZlBnHWWdLjY0TufpaELrn+Vufm
         +bAaZWTegfAhnj555Rf8P/h+GtcXPOdu3MOOAqLrQ0omA/fA2S/cxke6ppTqVm5beD8D
         Twltj6JFaP6xuZQ4dJbOtFQjZRP7jz9EUVDdZoMhOk3DsYVF/CqPRXx+Qf1UHxCakFdH
         oiQw==
X-Forwarded-Encrypted: i=1; AHgh+RrvAHYlMYCbsMLqgnMOs0opQeOk2Cgq0xqllw5UNvvR3Q9EN509VYf0QNeWVMjY6bQxKoRv41NTKFuZ7NeXmg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi4bI6hhMI2c1KnlAOJ5e8DeG1c0+GCYRN1BuSPboSC65tZ0QT
	6usp0piTSAmiuviOkW/cct5GNU2c8chnmxkkr++lqmPp9w51dibz1kUcT0zrbR/fyfM2uzoLeQP
	Sa9J6hI0U2mjuVZCVR4pAgtx93BWbnOKcoXzdmmJ9yaU0znx4PQBO5thaztA=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f8a:b0:495:f79d:b08e with SMTP id
 5614622812f47-4af5e303c5dmr21014265b6e.21.1785846745378; Tue, 04 Aug 2026
 05:32:25 -0700 (PDT)
Date: Tue, 04 Aug 2026 05:32:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a71dbd9.13623e66.bdc14.0015.GAE@google.com>
Subject: [syzbot] Monthly wireless report (Aug 2026)
From: syzbot <syzbot+listc15ef80f53a7511baad1@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello wireless maintainers/developers,

This is a 31-day syzbot report for the wireless subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/wireless

During the period, 0 new issues were detected and 1 were fixed.
In total, 29 issues are still open and 181 have already been fixed.
There are also 20 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  6979    Yes   WARNING in __cfg80211_ibss_joined (2)
                   https://syzkaller.appspot.com/bug?extid=7f064ba1704c2466e36d
<2>  1283    Yes   INFO: task hung in reg_process_self_managed_hints
                   https://syzkaller.appspot.com/bug?extid=1f16507d9ec05f64210a
<3>  633     Yes   INFO: task hung in crda_timeout_work (8)
                   https://syzkaller.appspot.com/bug?extid=d41f74db64598e0b5016
<4>  342     Yes   INFO: task hung in ath9k_hif_usb_firmware_cb (3)
                   https://syzkaller.appspot.com/bug?extid=e9b1ff41aa6a7ebf9640
<5>  105     Yes   KASAN: stack-out-of-bounds Write in carl9170_handle_command_response
                   https://syzkaller.appspot.com/bug?extid=5c1ca6ccaa1215781cac
<6>  89      Yes   WARNING in cfg80211_scan_done
                   https://syzkaller.appspot.com/bug?extid=189dcafc06865d38178d
<7>  55      No    WARNING in cfg80211_switch_netns
                   https://syzkaller.appspot.com/bug?extid=3515319a302224e081b4
<8>  47      Yes   WARNING: ODEBUG bug in ieee80211_led_exit (2)
                   https://syzkaller.appspot.com/bug?extid=e84ecca6d1fa09a9b3d9
<9>  37      Yes   INFO: task hung in nl80211_pre_doit (3)
                   https://syzkaller.appspot.com/bug?extid=da14e8c0ada830335981
<10> 20      Yes   WARNING in __cfg80211_bss_update (2)
                   https://syzkaller.appspot.com/bug?extid=1a797e1c81be78a2ace7

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
