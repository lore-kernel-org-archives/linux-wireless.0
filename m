Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab1C1NBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 09:01:53 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2SD1rxu020534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 09:01:53 -0400
Date: Mon, 28 Mar 2011 15:01:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945: microcode SW error log decode?
Message-ID: <20110328130134.GA4037@redhat.com>
References: <1300083494.6654.1.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1300083494.6654.1.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 14, 2011 at 01:18:13AM -0500, Dan Williams wrote:
> https://bugzilla.gnome.org/show_bug.cgi?id=644551
> 
> that has this error log in it.  Is that enough to figure out where
> things have gone wrong in the firmware?
> 
> [ 1286.750258] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
> [ 1286.750268] iwl3945 0000:03:00.0: Loaded firmware version: 15.32.2.9
> [ 1286.750304] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
> [ 1286.750309] iwl3945 0000:03:00.0: Status: 0x0002A2E4, count: 1
> [ 1286.750314] iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
> [ 1286.750543] iwl3945 0000:03:00.0: SYSASSERT     (0x5) 0001680217 0x008B6 0x13756 0x00320 0x00000 764
> [ 1286.750547] 
> [ 1286.750677] iwl3945 0000:03:00.0: Start IWL Event Log Dump: display last 20 count
> [ 1286.750720] iwl3945 0000:03:00.0: 0001679867 0x00000001      1106
> [ 1286.750746] iwl3945 0000:03:00.0: 0001679867 0x0000000f      1106
> [ 1286.750771] iwl3945 0000:03:00.0: 0001679869 0x00000428      1105
> [ 1286.750796] iwl3945 0000:03:00.0: 0001679873 0x00000483      1115
> [ 1286.750821] iwl3945 0000:03:00.0: 0001679876 0x00000006      0463
> [ 1286.750846] iwl3945 0000:03:00.0: 0001679877 0x00000006      0462
> [ 1286.750871] iwl3945 0000:03:00.0: 0001680003 0x04130097      0401
> [ 1286.750896] iwl3945 0000:03:00.0: 0001680005 0x00000006      0451
> [ 1286.750921] iwl3945 0000:03:00.0: 0001680025 0x00000000      0451
> [ 1286.750947] iwl3945 0000:03:00.0: 0001680157 0x44140080      0401
> [ 1286.750972] iwl3945 0000:03:00.0: 0001680172 0x00000017      0452
> [ 1286.750997] iwl3945 0000:03:00.0: 0001680177 0x00113b6e      0450
> [ 1286.751023] iwl3945 0000:03:00.0: 0001680182 0x00113b6e      0450
> [ 1286.751048] iwl3945 0000:03:00.0: 0001680187 0x00113b6e      0450
> [ 1286.751073] iwl3945 0000:03:00.0: 0001680192 0x00113b6e      0450
> [ 1286.751098] iwl3945 0000:03:00.0: 0001680197 0x00113b6e      0450
> [ 1286.751123] iwl3945 0000:03:00.0: 0001680202 0x00123b6e      0450
> [ 1286.751148] iwl3945 0000:03:00.0: 0001680207 0x00123b6e      0450
> [ 1286.751173] iwl3945 0000:03:00.0: 0001680213 0x00123b6e      0450
> [ 1286.751198] iwl3945 0000:03:00.0: 0001680218 0x00000100      0125
> [ 1286.751212] iwl3945 0000:03:00.0: Error Reply type 0x000002FC cmd REPLY_SCAN_CMD (0x80) seq 0x4414 ser 0x00340000
> [ 1286.755637] iwl3945 0000:03:00.0: Can't stop Rx DMA.

We have information that disable_hw_scan=1 workaround that problem.
That would be second reason to use software scanning by default,
first was very bad performance on some configurations. I'm going
to post a patch, which change that option on iwl3945.

Stanislaw
