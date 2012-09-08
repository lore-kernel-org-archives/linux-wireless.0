Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65486 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2IHDeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 23:34:36 -0400
Received: by qcro28 with SMTP id o28so154309qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 20:34:33 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 8 Sep 2012 11:34:33 +0800
Message-ID: <CAPgLHd-DabDrNN9KpQjG+XiXJDA38_VA2jeiF+O-7QBqNhEogA@mail.gmail.com> (sfid-20120908_053537_427742_401DBBBD)
Subject: Re: [PATCH v2] NFC: pn544_hci: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/2012 10:03 AM, Larry Finger wrote:
> On 09/07/2012 08:53 PM, Wei Yongjun wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> The dereference should be moved below the NULL test.
>>
>> spatch with a semantic match is used to found this.
>> (http://coccinelle.lip6.fr/)
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> ---
>>  
>
> As long as you are reworking this section, doesn't BUG_ON seem a little harsh? I do not think the kernel should ever be crashed because a non-essential driver is messed up. As the patch would be a totally different change, it should be a new submission, but I think each of these conditions should trigger a WARN_ON_ONCE, and return IRQ_NONE when they occur.
>
You means the should be like this?

diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
index aa71807..e42b100 100644
--- a/drivers/nfc/pn544_hci.c
+++ b/drivers/nfc/pn544_hci.c
@@ -341,13 +341,16 @@ flush:
 static irqreturn_t pn544_hci_irq_thread_fn(int irq, void *dev_id)
 {
 	struct pn544_hci_info *info = dev_id;
-	struct i2c_client *client = info->i2c_dev;
+	struct i2c_client *client;
 	struct sk_buff *skb = NULL;
 	int r;
 
-	BUG_ON(!info);
-	BUG_ON(irq != info->i2c_dev->irq);
+	if (!info || irq != info->i2c_dev->irq) {
+		WARN_ON_ONCE(1);
+		return IRQ_NONE;
+	}
 
+	client = info->i2c_dev;
 	dev_dbg(&client->dev, "IRQ\n");
 
 	if (info->hard_fault != 0)



