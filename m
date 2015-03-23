Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49097 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbCWSDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 14:03:42 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] hs20:  Update hs20 server notes file.
Date: Mon, 23 Mar 2015 14:03:38 -0400
Message-Id: <1427133818-21480-2-git-send-email-greearb@candelatech.com> (sfid-20150323_190353_123218_01E356FF)
In-Reply-To: <1427133818-21480-1-git-send-email-greearb@candelatech.com>
References: <1427133818-21480-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Include example hostapd-radius config file for the OSEN radius
server.  Show example of how to use the ca/setup.sh script to
generate keys.

Show how to start OCSP responder and generate the ocsp cache
file.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 hs20/server/hs20-osu-server.txt | 53 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/hs20/server/hs20-osu-server.txt b/hs20/server/hs20-osu-server.txt
index 80985f7..1557248 100644
--- a/hs20/server/hs20-osu-server.txt
+++ b/hs20/server/hs20-osu-server.txt
@@ -100,6 +100,19 @@ sqlite3 /home/user/hs20-server/AS/DB/eap_user.db < sql-example.txt
 # the examples as-is for initial testing).
 cp -r www /home/user/hs20-server
 
+# Build local keys and certs
+cd ca
+# Display help options.
+./setup.sh -h
+
+# Remove old keys, fill in appropriate values, and generate your keys.  For instance:
+./clean.sh
+rm -fr rootCA"
+old_hostname=myserver.local
+./setup.sh -C "Hotspot 2.0 Trust Root CA - CT" -d $old_hostname \
+   -I "Hotspot 2.0 Intermediate CA - CT" -o $old_hostname-osu-client \
+   -O $old_hostname-oscp -p lanforge -S $old_hostname -V $old_hostname-osu-revoked \
+   -m local -u http://$old_hostname:8888/
 
 # Configure subscription policies
 mkdir -p /home/user/hs20-server/spp/policy
@@ -128,6 +141,7 @@ EOF
 # Configure RADIUS authentication service
 # Note: Change the URL to match the setup
 # Note: Install AAA server key/certificate and root CA in Key directory
+# NOTE: ca.pem is a copy of the hs20-server/ca/ca.pem file
 
 cat > /home/user/hs20-server/AS/as-sql.conf <<EOF
 driver=none
@@ -156,6 +170,45 @@ cd /home/user/hs20-server/AS
 ./hostapd -B as-sql.conf
 
 
+OSEN Radius configuration notes.
+
+The OSEN RADIUS server config file should have the 'ocsp_stapling_response'
+configuration in it.  For example:
+
+# hostapd-radius config for the radius used by the OSEN AP
+interface=eth0#0
+driver=wired
+logger_syslog=-1
+logger_syslog_level=2
+logger_stdout=-1
+logger_stdout_level=2
+ctrl_interface=/var/run/hostapd
+ctrl_interface_group=0
+#ieee8021x=1
+eapol_key_index_workaround=0
+eap_server=1
+eap_user_file=/home/user/hs20-server/AS/hostapd.eap_user
+server_id=ben-ota-2-osen
+eap_sim_db=unix:/tmp/hlr_auc_gw.sock
+radius_server_auth_port=1811
+radius_server_clients=/home/user/hs20-server/AS/hostap.radius_clients
+
+ca_cert=/home/user/hs20-server/ca/ca.pem
+server_cert=/home/user/hs20-server/ca/server.pem
+private_key=/home/user/hs20-server/ca/server.key
+private_key_passwd=whatever
+
+ocsp_stapling_response=/home/user/hs20-server/ca/ocsp-server-cache.der
+
+
+# Run OCSP server:
+cd /home/user/hs20-server/ca
+./ocsp-responder.sh&
+
+# Update cache (This should be run periodically, but once will work for testing)
+./ocsp-update-cache.sh
+
+
 Configure web server
 --------------------
 
-- 
1.9.3

