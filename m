Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.75.44.102
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632742;
	b=Oo1pNNI9j5sOfhup8uj7oTGZZysOC30H29bHE/QfQgQfoX7zj69G+tft4y21wawsRPIT
	 xRQpEjL59VDrm6RyN2KPYCyjPfUuMutoC7xVhIwCglY1nBR71MC5K0tdM4DCsDXKkstAD
	 coku9nBM1POLzTK3Unn8eXZu6g+YiVCkBy6I+BifLRluzF5mk/IgZQ9GiSH48j+7qFi+/
	 tMhtK7uPSdpOcCeoXoNoK7yoV8gwahw7wUaXjam8trYiixICY0HpAUrC6ujYdZiqGPZQz
	 1XnW+dyqEhF6ar6gtxVgdPtZTkufOjM18sVNu5muAi9Q821K3stpk4jD/rCD7cxyIbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632742;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=kI8rcRdXw6K/f+Gxl/HJn8jJJhOYr8CMBPyP4ck+f7w=;
	b=cZPe3vNmnufyrUc+JauGOXqkeMHexmAv5IPwXHj/6SszygeCzgxUPmHrcPYRgWoCosdB
	 K4zdl3EFMEv8TJrgaBe7S5f6Ims8RtccnAaAJqBrmDKVvtCmE53kAcEYij4vpY78224eZ
	 2xTf7G7MJbFzoQXFKElAzekzYp56CW0nUydJ04b/QbzPCT+6VR1iKEc31YySGFSTd903U
	 IBSysoP2Io8Sqalzv6QbRJB0XzO6V8K6hSawme+LCRhCLvGPqp92m9tn4JV35av8rsJxU
	 vSaD+jT9RBe4bRihtogM8xsM6Xklg2F+i+ncnBrdwu2iZ0ri5TcRVQPU44zBuDuHhTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=lzu.edu.cn;
	spf=pass smtp.mailfrom=lzu.edu.cn;
	arc=none smtp.remote-ip=13.75.44.102
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4127606A5A6
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 15:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4127606A5A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [219.141.235.82])
	by app1 (Coremail) with SMTP id ygmowACnwLrZqehqmLaKAg--.14897S3;
	Mon, 02 Nov 2026 23:18:50 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	beni.lev@intel.com,
	emmanuel.grumbach@intel.com,
	bird@lzu.edu.cn,
	rakukuip@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH wireless 1/1] wifi: cfg80211: avoid OOB read in get_bss tracepoint
Date: Mon,  2 Nov 2026 23:15:43 +0800
Message-ID: <3714d87de39da7f9edd7fd9e603cc5f11e76e8aa.1793460263.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1793460263.git.rakukuip@gmail.com>
References: <cover.1793460263.git.rakukuip@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowACnwLrZqehqmLaKAg--.14897S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr4fWF13ZrW5tw13AryUAwb_yoW8ArW8pr
	yfu342kr95JFyqywn7tayFyryUua1kJFZxKFn8Ka4ruF1rWFs5ur1YgF1aqFyFkF4Yyay5
	WF4UtFyqyFs5ZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF0_Jw1lc2xSY4AK67AK
	6ryrMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GrWl4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfU8KZXUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQATCWrn6TwPMgAAs+

From: Luxiao Xu <rakukuip@gmail.com>

In TRACE_EVENT(cfg80211_get_bss), the ssid payload is declared as a
dynamic array sized by ssid_len:

    __dynamic_array(u8, ssid, ssid_len)

However, TP_printk unconditionally reads the first byte of ssid:

    ((u8 *)__get_dynamic_array(ssid))[0]

User space requests such as nl80211_authenticate() determine ssid_len
directly from netlink attribute length via nla_len(). When user space
passes a zero-length NL80211_ATTR_SSID, cfg80211_get_bss() is called
with ssid_len == 0. In this case, the dynamic array has a length of 0
bytes, but TP_printk still attempts to read index 0 when reading from
trace_pipe, triggering a KASAN slab-out-of-bounds read.

Check __get_dynamic_array_len(ssid) before accessing the array, returning
0 if the SSID length is zero.

Fixes: 4ee3e063f10a ("cfg80211: add cfg80211 exported function tracing")
Cc: stable@vger.kernel.org
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/wireless/trace.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 31000ffebe43..5eabd3b9823c 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3971,7 +3971,9 @@ TRACE_EVENT(cfg80211_get_bss,
 	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT ", %pM"
 		  ", buf: %#.2x, bss_type: %d, privacy: %d",
 		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->bssid,
-		  ((u8 *)__get_dynamic_array(ssid))[0], __entry->bss_type,
+		  __get_dynamic_array_len(ssid) ?
+		  ((u8 *)__get_dynamic_array(ssid))[0] : 0,
+		  __entry->bss_type,
 		  __entry->privacy)
 );
 
-- 
2.43.0

