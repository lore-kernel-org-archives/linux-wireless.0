Received: from mxs2.meta.ua (mxs2.meta.ua [194.0.131.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86A22DB7BD
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 07:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.0.131.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784015071; cv=none; b=BYCPc3rxMzGqryi9c5aB8r2GyBFhRI5HOowONixDS3Dm1MtDqSyGjp3Y9ztjWufwcAvw2t5lIBeK+V2DS19zg1pLTT5z6KMj/D5EQrPHELTI75zoKoOWPN8WVHHb7N7+Ede9gmVk2S7crrolAtcAbTYe+VQ+fMLioZnmvb6hnUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784015071; c=relaxed/simple;
	bh=CGIA2b8VVmuOx8ikveP3bcf/O+15i9BfBHmAkLgVBCM=;
	h=Message-ID:Date:Subject:From:To:Cc:MIME-Version:Content-Type; b=htI5f3iRBqtCxR9wfcnl6ILYBBnisRkeN5AyXYhuFCir2F5gEAgRNBXB2BqfxqF9CZfeezkqSTUcXloT4coM3BtCw8C1m0he7qZ9E3pQlVhaqnDj9sIp+DN5tYInAcZOFe5vNhcbPOVGv+qvuHzu2VE95yHWpkbu936HwHknIkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=meta.ua; spf=pass smtp.mailfrom=meta.ua; dkim=pass (2048-bit key) header.d=meta.ua header.i=@meta.ua header.b=CgmA6oG1; arc=none smtp.client-ip=194.0.131.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=meta.ua
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.ua
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.ua header.i=@meta.ua header.b="CgmA6oG1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=meta.ua;
	s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Reply-To:Cc:To:
	From:Subject:Date:Message-ID:Sender:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Vu7tMDh+hyGXe1mtCCC9wzVvrkvdBl3/KuK0YMVgM74=; b=CgmA6oG1ZD9rlwV2fYPiWy2sOG
	QG23syQydXJ0h4SgUdry4F+/WC/CoZcEAly5L1J5tvbGdwIxU4IfceEhSOMw1Typ7HSw9mmOoauKn
	xXb6/IKfwZgMETB2rLr7xjOzHZHaio/YjO/Hnvwjhi2ri3bUKCGzkGlgv+RY4QfUnfLu99lIr0wq3
	5QvqE24sjJ0Bn0SxAh12jixJyd2HNdGepcIQX4NhnbXHEU4NhlH418mhLzSZQPn/L9zkh2C8tjRq1
	qcpLib/MmDzCUPvD1zIZgyGSQYuf8FOaKTx2YFzX7cPzoyUaRa/kudoGdw+1i8f2sYOFUsT+dchAs
	oeHNfksA==;
Received: from 185.222.23.114
        (MetaMail authenticated user nurofen55@meta.ua)
        by mail.meta.ua with HTTP;
        Tue, 14 Jul 2026 10:43:10 +0300 (EEST)
Message-ID: <60828.185.222.23.114.1784014990.metamail@mail.meta.ua>
Date: Tue, 14 Jul 2026 10:43:10 +0300 (EEST)
Subject: [BUG] rtw89: 8852be intermittent 2.4GHz packet loss regression
 7.0.12 -> 7.1.x
From: nurofen55@meta.ua
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com
Reply-To: nurofen55@meta.ua
User-Agent: MetaMail/1.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Priority: 3 (Normal)
Importance: Normal
X-Browser: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like
 Gecko) Chrome/150.0.0.0 Safari/537.36
MetaPassport-Id: 11250186
X-HddSpool: 1
X-Gen: 0078195ddc5d4f825a8f28daa7541649

Hi,
I'd like to report a regression in the rtw89 driver (RTL8852BE) affecting 2.4GHz stability, introduced somewhere between kernel 7.0.12 and 7.1.x. This was originally filed on openSUSE bugzilla (bug 1271359), and Jiri Slaby suggested I forward it here for visibility with the driver maintainers:
https://bugzilla.opensuse.org/show_bug.cgi?id=1271359
Summary:

After updating from kernel 7.0.12 to the 7.1.x series (tested on 7.1.2 and 7.1.3) on openSUSE Tumbleweed, intermittent connectivity issues appear specifically on the 2.4GHz band. On kernel 7.0.12, both 2.4GHz and 5GHz bands were equally stable at the same physical location. On kernel 7.1.x, the 5GHz band remains fully stable at the same location, while the 2.4GHz band exhibits intermittent high-latency/packet-loss events.
Hardware:

- Laptop: Lenovo IdeaPad Slim 3 15ARP10

- CPU: AMD Ryzen 7 7735HS

- Wi-Fi: Realtek RTL8852BE (rtw89_8852be), PCIe

- Firmware: rtw89/rtw8852b_fw-2.bin, version 0.29.29.18 (9e3d777f) - unchanged throughout all testing (ruled out as a factor)
Steps to reproduce:

1. Boot into kernel 7.1.x (reproduced on both 7.1.2 and 7.1.3)

2. Connect to the 2.4GHz SSID at a location with moderate signal (around -70 dBm)

3. Run continuous monitoring (mtr/ping) while using the connection normally

4. Intermittent packet loss / latency spikes occur; the same location/conditions on the 5GHz SSID show no such issue
Captured evidence of one event (kernel 7.1.3), mtr output during the drop:
HOST: localhost.localdomain    Loss%   Snt   Last   Avg   Best  Wrst  StDev

1.|-- 192.168.0.109            20.0%    10   3018.  958.6  9.0  3018. 1234.6

     192.168.0.1
A single packet showed about 3018 ms latency with 20% loss recorded during the sample.
Notably, no corresponding entries appear in dmesg/journalctl during this event - no deauth, no driver error, no firmware timeout. iw dev wlp2s0 station dump immediately after showed the link as fully healthy: 0 tx retries, 0 tx failed, beacon loss 0. This suggests the packet loss happens at a level not surfaced by driver logging (possibly interference handling, channel contention, or power-save logic specific to 2.4GHz), rather than a link-layer disconnect.
Expected behavior:

2.4GHz stability matching kernel 7.0.12 behavior (equivalent to current 5GHz stability on 7.1.x).
Actual behavior:

Intermittent high-latency/packet-loss events on 2.4GHz only, with kernel 7.1.x; not reproduced on 5GHz under the same conditions; not reproduced on 2.4GHz under kernel 7.0.12.
Additional info:

Kernel 7.0.12 is no longer installable via zypper in the current Tumbleweed OSS repo, so I'm currently unable to do further direct A/B testing against 7.0.12 - this report is based on testing done while 7.0.12 was still available. I understand older builds may still be available via download.opensuse.org/history if a fresh comparison is needed.
I'm happy to test patches, run bisection guidance, or gather any additional debug output (debugfs, ethtool stats, etc.) if that would help narrow this down.
Thanks,

Sviatoslav

