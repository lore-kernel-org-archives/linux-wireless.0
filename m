Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:38098 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaHYG2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 02:28:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v8 2/4] ath10k: provide firmware crash info via debugfs
References: <20140821124705.27159.67898.stgit@potku.adurom.net>
	<20140821124907.27159.64620.stgit@potku.adurom.net>
	<CA+BoTQk6wvXMEWnfFvASJwzj2AC0VB=Zby+zLO-tJ3NN_eA2mg@mail.gmail.com>
Date: Mon, 25 Aug 2014 09:28:48 +0300
In-Reply-To: <CA+BoTQk6wvXMEWnfFvASJwzj2AC0VB=Zby+zLO-tJ3NN_eA2mg@mail.gmail.com>
	(Michal Kazior's message of "Fri, 22 Aug 2014 08:49:35 +0200")
Message-ID: <878umd84m7.fsf@kamboji.qca.qualcomm.com> (sfid-20140825_082857_560140_3335CE2A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 21 August 2014 14:49, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
>> +static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
>> +{
>> +       struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
>> +       struct ath10k_dump_file_data *dump_data;
>> +       struct ath10k_tlv_dump_data *dump_tlv;
>> +       int hdr_len = sizeof(*dump_data);
>> +       unsigned int len, sofar = 0;
>> +       unsigned char *buf;
>> +
>> +       lockdep_assert_held(&ar->conf_mutex);
> [...]
>> +static int ath10k_fw_crash_dump_open(struct inode *inode, struct file *file)
>> +{
>> +       struct ath10k *ar = inode->i_private;
>> +       struct ath10k_dump_file_data *dump;
>> +       int ret;
>> +
>> +       mutex_lock(&ar->conf_mutex);
>
> I don't think we need conf_mutex here at all, do we?

You are right, I removed that (diff below).

> I'm sorry, I should've spotted this earlier. Feel free to just ignore
> me :-)

Hehe, no worries. It's difficult to spot all problems in the first
review and I do that all the time :)

> Other than that this looks fine.

Great, thanks for good review!

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index bf08f026b202..442fe93d18be 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -712,8 +712,6 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
 	unsigned int len, sofar = 0;
 	unsigned char *buf;
 
-	lockdep_assert_held(&ar->conf_mutex);
-
 	len = hdr_len;
 	len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
 
@@ -785,22 +783,14 @@ static int ath10k_fw_crash_dump_open(struct inode *inode, struct file *file)
 {
 	struct ath10k *ar = inode->i_private;
 	struct ath10k_dump_file_data *dump;
-	int ret;
-
-	mutex_lock(&ar->conf_mutex);
 
 	dump = ath10k_build_dump_file(ar);
-	if (!dump) {
-		ret = -ENODATA;
-		goto out;
-	}
+	if (!dump)
+		return -ENODATA;
 
 	file->private_data = dump;
-	ret = 0;
 
-out:
-	mutex_unlock(&ar->conf_mutex);
-	return ret;
+	return 0;
 }
 
 static ssize_t ath10k_fw_crash_dump_read(struct file *file,


-- 
Kalle Valo
