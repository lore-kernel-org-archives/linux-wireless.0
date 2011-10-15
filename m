Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27071 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab1JOAwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 20:52:50 -0400
From: "Panjwani, Rishi" <rpanjwan@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] ath6kl: Implement support for QOS-enable and
 QOS-disable from userspace
Date: Sat, 15 Oct 2011 00:52:48 +0000
Message-ID: <278E1D5A6E59CE43BFCE41F2BC5946C917664695@nasanexd02a.na.qualcomm.com> (sfid-20111015_025254_036225_0108D372)
References: <1318639687-28457-1-git-send-email-rpanjwan@qca.qualcomm.com>
 <1318639687-28457-2-git-send-email-rpanjwan@qca.qualcomm.com>
In-Reply-To: <1318639687-28457-2-git-send-email-rpanjwan@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

Kindly ignore the previous patch I had sent out. This is the patch I am looking forward to get publically reviewed and committed :

-----Original Message-----
From: Panjwani, Rishi 
Sent: Friday, October 14, 2011 5:48 PM
To: Valo, Kalle
Cc: linux-wireless@vger.kernel.org; Panjwani, Rishi
Subject: [PATCH] ath6kl: Implement support for QOS-enable and QOS-disable from userspace

In order to allow user space based QOS control we use the available debugfs infrastructure. With this feature, user can make changes to qos parameters, thereby allowing creation and deletion of user defined priority streams and features like uapsd. This feature has been added for testing purposes.

All 21 parameters for the create_qos command are mandatory in the correct order. They have to be written to the create_qos file in the ath6kl debug directory. These parameters(in order) are:
1)user priority
2)direction
3)traffic class
4)traffic type
5)voice PS capability
6)min service intvl
7)max service intvl
8)inactivity intvl
9)suspension intvl
10)serv start time
11)tsid
12)nominal msdu
13)max msdu
14)min data rate
15)mean data rate
16)peak data rate
17)max burst size
18)delay bound
19)min phy rate
20)surplus bw allowance
21)medium time
For eg :
echo "6 2 3 1 1 9999999 9999999 9999999 7777777 0 6 45000 200 56789000
56789000 5678900 0 0 9999999 20000 0" > create_qos

delete_qos requires 2 parameters:
1)traffic class
2)tsid
For eg :
echo "3 1" > delete_qos

Signed-off-by: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |  250 +++++++++++++++++++++++++++++--
 1 files changed, 236 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index dd37785..383a3c7 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1240,6 +1240,222 @@ static const struct file_operations fops_disconnect_timeout = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath6kl_create_qos_write(struct file *file,
+						const char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+
+	struct ath6kl *ar = file->private_data;
+	char buf[100];
+	ssize_t len;
+	char *sptr, *token;
+	struct wmi_create_pstream_cmd pstream;
+	u32 val32;
+	u16 val16;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+	sptr = buf;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou8(token, 0, &pstream.user_pri))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou8(token, 0, &pstream.traffic_direc))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou8(token, 0, &pstream.traffic_class))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou8(token, 0, &pstream.traffic_type))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou8(token, 0, &pstream.voice_psc_cap))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.min_service_int = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.max_service_int = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.inactivity_int = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.suspension_int = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.service_start_time = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou8(token, 0, &pstream.tsid))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou16(token, 0, &val16))
+		return -EINVAL;
+	pstream.nominal_msdu = cpu_to_le16(val16);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou16(token, 0, &val16))
+		return -EINVAL;
+	pstream.max_msdu = cpu_to_le16(val16);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.min_data_rate = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.mean_data_rate = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.peak_data_rate = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.max_burst_size = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.delay_bound = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.min_phy_rate = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.sba = cpu_to_le32(val32);
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou32(token, 0, &val32))
+		return -EINVAL;
+	pstream.medium_time = cpu_to_le32(val32);
+
+	ath6kl_wmi_create_pstream_cmd(ar->wmi, &pstream);
+
+	return count;
+}
+
+
+static const struct file_operations fops_create_qos = {
+	.write = ath6kl_create_qos_write,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t ath6kl_delete_qos_write(struct file *file,
+				const char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+
+	struct ath6kl *ar = file->private_data;
+	char buf[100];
+	ssize_t len;
+	char *sptr, *token;
+	u8 traffic_class;
+	u8 tsid;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+	sptr = buf;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou8(token, 0, &traffic_class))
+		return -EINVAL;
+
+	token = strsep(&sptr, " ");
+	if (!token)
+		return -EINVAL;
+	if (kstrtou8(token, 0, &tsid))
+		return -EINVAL;
+
+	ath6kl_wmi_delete_pstream_cmd(ar->wmi, traffic_class, tsid);
+
+	return count;
+}
+
+
+static const struct file_operations fops_delete_qos = {
+	.write = ath6kl_delete_qos_write,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)  {
 	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE); @@ -1313,6 +1529,12 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("disconnect_timeout", S_IRUSR | S_IWUSR,
 			    ar->debugfs_phy, ar, &fops_disconnect_timeout);
 
+	debugfs_create_file("create_qos", S_IWUSR, ar->debugfs_phy, ar,
+				&fops_create_qos);
+
+	debugfs_create_file("delete_qos", S_IWUSR, ar->debugfs_phy, ar,
+				&fops_delete_qos);
+
 	return 0;
 }
 
--
1.7.0.4

