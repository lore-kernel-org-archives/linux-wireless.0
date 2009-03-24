Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:37133 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZCXPRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 11:17:03 -0400
Message-ID: <49C8F93F.4030704@lwfinger.net> (sfid-20090324_161707_908496_0F72D9C4)
Date: Tue, 24 Mar 2009 10:16:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>,
	networkmanager-list <networkmanager-list@gnome.org>
Subject: Permissions problem in Dbus/NetworkManager
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently openSUSE issued an update for 11.1 to correct the Dbus security
problems descriBed in CVE-2009-0578. After this was done, I could no longer
connect using wifi encryption.

The NetworkManager log shows the following:

Mar 17 16:06:01 larrylap NetworkManager: <info>  Activation (wlan2/wireless):
access point 'lwfdjf_rad' has security, but secrets are required.
Mar 17 16:06:01 larrylap NetworkManager: <info>  (wlan2): device state change:
5 -> 6
Mar 17 16:06:01 larrylap NetworkManager: <info>  Activation (wlan2) Stage 2 of
5 (Device Configure) complete.
Mar 17 16:06:01 larrylap NetworkManager: <WARN>  get_secrets_cb(): Couldn't get
connection secrets: A security policy in place prevents this sender from sending
this message to this recipient, see message bus configuration file (rejected
message had interface "org.freedesktop.NetworkManagerSettings.Connection.Secrets"
member "GetSecrets" error name "(unset)" destination
"org.freedesktop.NetworkManagerUserSettings").

The problem seemed to be random. One reporter had two x86 systems that appeared
to be identical - one worked and one did not.

After going through the usual checks to make sure the contents of
/etc/dbus-1/system.d were correct, one of the openSUSE people discovered that
/var/run/dbus/at_console contained both a directory for the unprivileged user,
and an extra empty directory for root. As soon as the directory for root was
deleted, everything worked as expected. Testing was done with the following command:

dbus-send --system --print-reply \
--dest=org.freedesktop.NetworkManagerUserSettings \
/org/freedesktop/NetworkManagerSettings/Connection/0 \
org.freedesktop.NetworkManagerSettings.Connection.Secrets.GetSecrets

This command returned an error when called as an unprivileged user, and the
expected result when used as root. Before the extraneous directory was deleted,
all users failed.

This problem was covered in the openSUSE Bugzilla #486267. I posted it here for
those openSUSE users that might not be perusing the bug list, and just in case
users of another distro might be affected.

Larry

