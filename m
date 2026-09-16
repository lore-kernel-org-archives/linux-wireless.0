Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AA0414A11
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 19:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789587088; cv=none; b=Ec/rP3o0cNvHnQwXQIHVcxqb0X1d+151DmNgaNIj3dxAYrpf+5PZdKxeqZW7WXAPlrtLfUM6oGjBYEuwi4tB0LUDWg8INMZlhJ4L0w1dUlg0rC/u9Zso5ehTr1V5CE0S6+WKBSjVjbIFXqjxEDBjPuJ0xKtVNvbC7QqaIE+rywE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789587088; c=relaxed/simple;
	bh=7adOtyWFomUrHmMFowVzhJrp4bsLCjelS2sNaES72MA=;
	h=Message-ID:Date:MIME-Version:From:Cc:Subject:To:Content-Type; b=BxbMr1NmPzk3cL5M0jIoPX2sF9gYYbjhNnPrsLMNZTmTftKK8YY4rCp9Ai+mGdBtX0haLt9udVPTMhqk38LKiPesVc6bSEvcd8JZ7fotC67brlaAPnKCfZxNQenegHjP75VMwP5nGYaUXUL+RkQzsNXuKPVpuzAZBNfnHTAX1Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jsGHeUdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jsGHeUdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978DE1F000FF;
	Wed, 16 Sep 2026 19:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789587070;
	bh=MflAZ9VFs+mJplr90tKYaYlL+pJXFiWY2MYCWYiwWXg=;
	h=Date:From:Cc:Subject:To;
	b=jsGHeUdYrrTKWgnpWFrYXMNzR9JHZCidswZ4NicZtqJIqOC47zBbQj/tY6T42P6AC
	 2NMQuMc6ZsLVor3Hx49aOma7Sw/a4SRyWyNHifYVZ+sHYp2CN0mm0fH19aDQcRdGYE
	 sV9h0Dfg1ItyxvkK6XBXGMyk5wzM+t0sirYqZGQPXC/b07sqoDXrvpFtnPogIayin8
	 IeUlXjaM51AWh3328Par2etSt0XGvt1aG6NApi1CTgAfSu9fJnyYmlzI5uEP2echRH
	 RMkvuapQueXhDi4fNAFacFj62R4g/SOHohoqecQSj7+aOT5tnZyS6+SHwQX2XnPwF8
	 bKivm6xMl0q7A==
Message-ID: <6810ccfb-0453-4bdc-bb03-d51c3f3c6e18@kernel.org>
Date: Wed, 16 Sep 2026 21:31:07 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Heiner Kallweit <hkall@kernel.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
 libertas-dev@lists.infradead.org, Kees Cook <kees@kernel.org>
Subject: [PATCH] libertas: mesh: remove unused and undocumented sysfs
 attribute groups
To: Johannes Berg <johannes@sipsolutions.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

7e79b38fe9a4 ("libertas: register sysfs groups properly")
changed the code to use struct net_device member sysfs_groups
array indices 1 and 2. However only one device-specific group
is supported by net core, see netdev_register_kobject().
As a result groups boot_opts_group and mesh_ie_group are
overwritten with net core internal groups.
Referenced change was done 5 yrs ago, and apparently nobody
has missed the sysfs attributes in the meantime. So I dare
to remove them, especially as they aren't documented under
Documentation/ABI.

Signed-off-by: Heiner Kallweit <hkall@kernel.org>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 506 -------------------
 1 file changed, 506 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index fced7485d..686b2e18a 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -65,19 +65,6 @@ static int __lbs_mesh_config_send(struct lbs_private *priv,
 	return ret;
 }
 
-static int lbs_mesh_config_send(struct lbs_private *priv,
-			 struct cmd_ds_mesh_config *cmd,
-			 uint16_t action, uint16_t type)
-{
-	int ret;
-
-	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
-		return -EOPNOTSUPP;
-
-	ret = __lbs_mesh_config_send(priv, cmd, action, type);
-	return ret;
-}
-
 /* This function is the CMD_MESH_CONFIG legacy function.  It only handles the
  * START and STOP actions.  The extended actions supported by CMD_MESH_CONFIG
  * are all handled by preparing a struct cmd_ds_mesh_config and passing it to
@@ -333,497 +320,6 @@ static const struct attribute_group lbs_mesh_attr_group = {
 	.attrs = lbs_mesh_sysfs_entries,
 };
 
-
-/***************************************************************************
- * Persistent configuration support
- */
-
-static int mesh_get_default_parameters(struct device *dev,
-				       struct mrvl_mesh_defaults *defs)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_config cmd;
-	int ret;
-
-	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_GET,
-				   CMD_TYPE_MESH_GET_DEFAULTS);
-
-	if (ret)
-		return -EOPNOTSUPP;
-
-	memcpy(defs, &cmd.data[0], sizeof(struct mrvl_mesh_defaults));
-
-	return 0;
-}
-
-/**
- * bootflag_show - Get function for sysfs attribute bootflag
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer where data will be returned
- */
-static ssize_t bootflag_show(struct device *dev,
-			     struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return sysfs_emit(buf, "%d\n", le32_to_cpu(defs.bootflag));
-}
-
-/**
- * bootflag_store - Set function for sysfs attribute bootflag
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer that contains new attribute value
- * @count: size of buffer
- */
-static ssize_t bootflag_store(struct device *dev, struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_config cmd;
-	uint32_t datum;
-	int ret;
-
-	ret = kstrtouint(buf, 10, &datum);
-	if (ret)
-		return ret;
-	if (datum > 1)
-		return -EINVAL;
-
-	memset(&cmd, 0, sizeof(cmd));
-	*((__le32 *)&cmd.data[0]) = cpu_to_le32(!!datum);
-	cmd.length = cpu_to_le16(sizeof(uint32_t));
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_BOOTFLAG);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * boottime_show - Get function for sysfs attribute boottime
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer where data will be returned
- */
-static ssize_t boottime_show(struct device *dev,
-			     struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return sysfs_emit(buf, "%d\n", defs.boottime);
-}
-
-/**
- * boottime_store - Set function for sysfs attribute boottime
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer that contains new attribute value
- * @count: size of buffer
- */
-static ssize_t boottime_store(struct device *dev,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_config cmd;
-	uint32_t datum;
-	int ret;
-
-	ret = kstrtouint(buf, 10, &datum);
-	if (ret)
-		return ret;
-	if (datum > 255)
-		return -EINVAL;
-
-	memset(&cmd, 0, sizeof(cmd));
-
-	/* A too small boot time will result in the device booting into
-	 * standalone (no-host) mode before the host can take control of it,
-	 * so the change will be hard to revert.  This may be a desired
-	 * feature (e.g to configure a very fast boot time for devices that
-	 * will not be attached to a host), but dangerous.  So I'm enforcing a
-	 * lower limit of 20 seconds:  remove and recompile the driver if this
-	 * does not work for you.
-	 */
-	datum = (datum < 20) ? 20 : datum;
-	cmd.data[0] = datum;
-	cmd.length = cpu_to_le16(sizeof(uint8_t));
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_BOOTTIME);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * channel_show - Get function for sysfs attribute channel
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer where data will be returned
- */
-static ssize_t channel_show(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return sysfs_emit(buf, "%d\n", le16_to_cpu(defs.channel));
-}
-
-/**
- * channel_store - Set function for sysfs attribute channel
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer that contains new attribute value
- * @count: size of buffer
- */
-static ssize_t channel_store(struct device *dev, struct device_attribute *attr,
-			     const char *buf, size_t count)
-{
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	struct cmd_ds_mesh_config cmd;
-	uint32_t datum;
-	int ret;
-
-	ret = kstrtouint(buf, 10, &datum);
-	if (ret)
-		return ret;
-	if (datum < 1 || datum > 11)
-		return -EINVAL;
-
-	memset(&cmd, 0, sizeof(cmd));
-	*((__le16 *)&cmd.data[0]) = cpu_to_le16(datum);
-	cmd.length = cpu_to_le16(sizeof(uint16_t));
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_DEF_CHANNEL);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * mesh_id_show - Get function for sysfs attribute mesh_id
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer where data will be returned
- */
-static ssize_t mesh_id_show(struct device *dev, struct device_attribute *attr,
-			    char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	if (defs.meshie.val.mesh_id_len > IEEE80211_MAX_SSID_LEN) {
-		dev_err(dev, "inconsistent mesh ID length\n");
-		defs.meshie.val.mesh_id_len = IEEE80211_MAX_SSID_LEN;
-	}
-
-	memcpy(buf, defs.meshie.val.mesh_id, defs.meshie.val.mesh_id_len);
-	buf[defs.meshie.val.mesh_id_len] = '\n';
-	buf[defs.meshie.val.mesh_id_len + 1] = '\0';
-
-	return defs.meshie.val.mesh_id_len + 1;
-}
-
-/**
- * mesh_id_store - Set function for sysfs attribute mesh_id
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer that contains new attribute value
- * @count: size of buffer
- */
-static ssize_t mesh_id_store(struct device *dev, struct device_attribute *attr,
-			     const char *buf, size_t count)
-{
-	struct cmd_ds_mesh_config cmd;
-	struct mrvl_mesh_defaults defs;
-	struct mrvl_meshie *ie;
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	int len;
-	int ret;
-
-	if (count < 2 || count > IEEE80211_MAX_SSID_LEN + 1)
-		return -EINVAL;
-
-	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
-	ie = (struct mrvl_meshie *) &cmd.data[0];
-
-	/* fetch all other Information Element parameters */
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
-
-	/* transfer IE elements */
-	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
-
-	len = count - 1;
-	memcpy(ie->val.mesh_id, buf, len);
-	/* SSID len */
-	ie->val.mesh_id_len = len;
-	/* IE len */
-	ie->len = sizeof(struct mrvl_meshie_val) - IEEE80211_MAX_SSID_LEN + len;
-
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_MESH_IE);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * protocol_id_show - Get function for sysfs attribute protocol_id
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer where data will be returned
- */
-static ssize_t protocol_id_show(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return sysfs_emit(buf, "%d\n", defs.meshie.val.active_protocol_id);
-}
-
-/**
- * protocol_id_store - Set function for sysfs attribute protocol_id
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer that contains new attribute value
- * @count: size of buffer
- */
-static ssize_t protocol_id_store(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf, size_t count)
-{
-	struct cmd_ds_mesh_config cmd;
-	struct mrvl_mesh_defaults defs;
-	struct mrvl_meshie *ie;
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	uint32_t datum;
-	int ret;
-
-	ret = kstrtouint(buf, 10, &datum);
-	if (ret)
-		return ret;
-	if (datum > 255)
-		return -EINVAL;
-
-	memset(&cmd, 0, sizeof(cmd));
-
-	/* fetch all other Information Element parameters */
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
-
-	/* transfer IE elements */
-	ie = (struct mrvl_meshie *) &cmd.data[0];
-	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
-	/* update protocol id */
-	ie->val.active_protocol_id = datum;
-
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_MESH_IE);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * metric_id_show - Get function for sysfs attribute metric_id
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer where data will be returned
- */
-static ssize_t metric_id_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return sysfs_emit(buf, "%d\n", defs.meshie.val.active_metric_id);
-}
-
-/**
- * metric_id_store - Set function for sysfs attribute metric_id
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer that contains new attribute value
- * @count: size of buffer
- */
-static ssize_t metric_id_store(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	struct cmd_ds_mesh_config cmd;
-	struct mrvl_mesh_defaults defs;
-	struct mrvl_meshie *ie;
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	uint32_t datum;
-	int ret;
-
-	memset(&cmd, 0, sizeof(cmd));
-	ret = sscanf(buf, "%d", &datum);
-	if ((ret != 1) || (datum > 255))
-		return -EINVAL;
-
-	/* fetch all other Information Element parameters */
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
-
-	/* transfer IE elements */
-	ie = (struct mrvl_meshie *) &cmd.data[0];
-	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
-	/* update metric id */
-	ie->val.active_metric_id = datum;
-
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_MESH_IE);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-/**
- * capability_show - Get function for sysfs attribute capability
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer where data will be returned
- */
-static ssize_t capability_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct mrvl_mesh_defaults defs;
-	int ret;
-
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	if (ret)
-		return ret;
-
-	return sysfs_emit(buf, "%d\n", defs.meshie.val.mesh_capability);
-}
-
-/**
- * capability_store - Set function for sysfs attribute capability
- * @dev: the &struct device
- * @attr: device attributes
- * @buf: buffer that contains new attribute value
- * @count: size of buffer
- */
-static ssize_t capability_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
-{
-	struct cmd_ds_mesh_config cmd;
-	struct mrvl_mesh_defaults defs;
-	struct mrvl_meshie *ie;
-	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	uint32_t datum;
-	int ret;
-
-	memset(&cmd, 0, sizeof(cmd));
-	ret = sscanf(buf, "%d", &datum);
-	if ((ret != 1) || (datum > 255))
-		return -EINVAL;
-
-	/* fetch all other Information Element parameters */
-	ret = mesh_get_default_parameters(dev, &defs);
-
-	cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie));
-
-	/* transfer IE elements */
-	ie = (struct mrvl_meshie *) &cmd.data[0];
-	memcpy(ie, &defs.meshie, sizeof(struct mrvl_meshie));
-	/* update value */
-	ie->val.mesh_capability = datum;
-
-	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
-				   CMD_TYPE_MESH_SET_MESH_IE);
-	if (ret)
-		return ret;
-
-	return strlen(buf);
-}
-
-
-static DEVICE_ATTR_RW(bootflag);
-static DEVICE_ATTR_RW(boottime);
-static DEVICE_ATTR_RW(channel);
-static DEVICE_ATTR_RW(mesh_id);
-static DEVICE_ATTR_RW(protocol_id);
-static DEVICE_ATTR_RW(metric_id);
-static DEVICE_ATTR_RW(capability);
-
-static struct attribute *boot_opts_attrs[] = {
-	&dev_attr_bootflag.attr,
-	&dev_attr_boottime.attr,
-	&dev_attr_channel.attr,
-	NULL
-};
-
-static const struct attribute_group boot_opts_group = {
-	.name = "boot_options",
-	.attrs = boot_opts_attrs,
-};
-
-static struct attribute *mesh_ie_attrs[] = {
-	&dev_attr_mesh_id.attr,
-	&dev_attr_protocol_id.attr,
-	&dev_attr_metric_id.attr,
-	&dev_attr_capability.attr,
-	NULL
-};
-
-static const struct attribute_group mesh_ie_group = {
-	.name = "mesh_ie",
-	.attrs = mesh_ie_attrs,
-};
-
-
 /***************************************************************************
  * Initializing and starting, stopping mesh
  */
@@ -1019,8 +515,6 @@ static int lbs_add_mesh(struct lbs_private *priv)
 
 	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 	mesh_dev->sysfs_groups[0] = &lbs_mesh_attr_group;
-	mesh_dev->sysfs_groups[1] = &boot_opts_group;
-	mesh_dev->sysfs_groups[2] = &mesh_ie_group;
 
 	/* Register virtual mesh interface */
 	ret = register_netdev(mesh_dev);
-- 
2.53.0

