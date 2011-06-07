Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41717 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1FGGeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 02:34:14 -0400
Received: by bwz15 with SMTP id 15so3907933bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 23:34:13 -0700 (PDT)
From: Bernhard Schmidt <bschmidt@freebsd.org>
Reply-To: bschmidt@freebsd.org
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [iwl4965] Microcode SW error detected
Date: Tue, 7 Jun 2011 08:32:48 +0200
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
References: <1306151106.2066.60.camel@x61.thuisdomein>
In-Reply-To: <1306151106.2066.60.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201106070832.49048.bschmidt@freebsd.org> (sfid-20110607_083418_701268_FE7C7FCE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, May 23, 2011 13:45:06 Paul Bolle wrote:
> 0) Since I started running (release candidates of) kernel v2.6.39 errors
> like these show up in my log, every now and then:
> 
> iwl4965 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
> iwl4965 0000:03:00.0: Loaded firmware version: 228.61.2.24
> iwl4965 0000:03:00.0: Start IWL Error Log Dump:
> iwl4965 0000:03:00.0: Status: 0x000213E4, count: 5
> iwl4965 0000:03:00.0: Desc                                  Time       data1      data2      line
> iwl4965 0000:03:00.0: FH_ERROR                     (0x000C) 1821446380 0x00000008 0x03130000 208 

On a unrelated site note, I have a case where I can trigger a
FH_ERROR at this line 100% reliably. Not on Linux though..
While being associated to a 5GHz BSS doing a scan chan by chan
(instead of all at once) is enough to trigger it. A workaround
is too not send probe requests for 2GHz channels at 1Mbps (CCK
flag) but at 6Mbps instead.

Maybe this bug report [1] is related too?

[1] http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1965

-- 
Bernhard
