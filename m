Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58157 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbcFIIPp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 04:15:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wext: reformat struct/union declarations
Date: Thu,  9 Jun 2016 10:15:40 +0200
Message-Id: <1465460140-8117-1-git-send-email-johannes@sipsolutions.net> (sfid-20160609_101556_190534_6ADCBC29)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Everytime I need to look for these, my usual strategy fails
because it assumes the right formatting. Fix the formatting
here to make it consistent with the rest of the kernel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/wireless.h | 63 +++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 41 deletions(-)

diff --git a/include/uapi/linux/wireless.h b/include/uapi/linux/wireless.h
index c1592e3e4036..d9ecd7c6d691 100644
--- a/include/uapi/linux/wireless.h
+++ b/include/uapi/linux/wireless.h
@@ -670,8 +670,7 @@
 /*
  *	Generic format for most parameters that fit in an int
  */
-struct	iw_param
-{
+struct iw_param {
   __s32		value;		/* The value of the parameter itself */
   __u8		fixed;		/* Hardware should not use auto select */
   __u8		disabled;	/* Disable the feature */
@@ -682,8 +681,7 @@ struct	iw_param
  *	For all data larger than 16 octets, we need to use a
  *	pointer to memory allocated in user space.
  */
-struct	iw_point
-{
+struct iw_point {
   void __user	*pointer;	/* Pointer to the data  (in user space) */
   __u16		length;		/* number of fields or size in bytes */
   __u16		flags;		/* Optional params */
@@ -698,8 +696,7 @@ struct	iw_point
  *	of 10 to get 'm' lower than 10^9, with 'm'= f / (10^'e')...
  *	The power of 10 is in 'e', the result of the division is in 'm'.
  */
-struct	iw_freq
-{
+struct iw_freq {
 	__s32		m;		/* Mantissa */
 	__s16		e;		/* Exponent */
 	__u8		i;		/* List index (when in range struct) */
@@ -709,8 +706,7 @@ struct	iw_freq
 /*
  *	Quality of the link
  */
-struct	iw_quality
-{
+struct iw_quality {
 	__u8		qual;		/* link quality (%retries, SNR,
 					   %missed beacons or better...) */
 	__u8		level;		/* signal level (dBm) */
@@ -725,8 +721,7 @@ struct	iw_quality
  *	is already pretty exhaustive, and you should use that first.
  *	This is only additional stats...
  */
-struct	iw_discarded
-{
+struct iw_discarded {
 	__u32		nwid;		/* Rx : Wrong nwid/essid */
 	__u32		code;		/* Rx : Unable to code/decode (WEP) */
 	__u32		fragment;	/* Rx : Can't perform MAC reassembly */
@@ -738,16 +733,14 @@ struct	iw_discarded
  *	Packet/Time period missed in the wireless adapter due to
  *	"wireless" specific problems...
  */
-struct	iw_missed
-{
+struct iw_missed {
 	__u32		beacon;		/* Missed beacons/superframe */
 };
 
 /*
  *	Quality range (for spy threshold)
  */
-struct	iw_thrspy
-{
+struct iw_thrspy {
 	struct sockaddr		addr;		/* Source address (hw/mac) */
 	struct iw_quality	qual;		/* Quality of the link */
 	struct iw_quality	low;		/* Low threshold */
@@ -765,8 +758,7 @@ struct	iw_thrspy
  *	Especially, scan results are required to include an entry for the
  *	current BSS if the driver is in Managed mode and associated with an AP.
  */
-struct	iw_scan_req
-{
+struct iw_scan_req {
 	__u8		scan_type; /* IW_SCAN_TYPE_{ACTIVE,PASSIVE} */
 	__u8		essid_len;
 	__u8		num_channels; /* num entries in channel_list;
@@ -827,8 +819,7 @@ struct	iw_scan_req
  *	RX_SEQ_VALID for SIOCGIWENCODEEXT are optional, but can be useful for
  *	debugging/testing.
  */
-struct	iw_encode_ext
-{
+struct iw_encode_ext {
 	__u32		ext_flags; /* IW_ENCODE_EXT_* */
 	__u8		tx_seq[IW_ENCODE_SEQ_MAX_SIZE]; /* LSB first */
 	__u8		rx_seq[IW_ENCODE_SEQ_MAX_SIZE]; /* LSB first */
@@ -841,8 +832,7 @@ struct	iw_encode_ext
 };
 
 /* SIOCSIWMLME data */
-struct	iw_mlme
-{
+struct iw_mlme {
 	__u16		cmd; /* IW_MLME_* */
 	__u16		reason_code;
 	struct sockaddr	addr;
@@ -855,16 +845,14 @@ struct	iw_mlme
 
 #define IW_PMKID_LEN	16
 
-struct	iw_pmksa
-{
+struct iw_pmksa {
 	__u32		cmd; /* IW_PMKSA_* */
 	struct sockaddr	bssid;
 	__u8		pmkid[IW_PMKID_LEN];
 };
 
 /* IWEVMICHAELMICFAILURE data */
-struct	iw_michaelmicfailure
-{
+struct iw_michaelmicfailure {
 	__u32		flags;
 	struct sockaddr	src_addr;
 	__u8		tsc[IW_ENCODE_SEQ_MAX_SIZE]; /* LSB first */
@@ -872,8 +860,7 @@ struct	iw_michaelmicfailure
 
 /* IWEVPMKIDCAND data */
 #define IW_PMKID_CAND_PREAUTH	0x00000001 /* RNS pre-authentication enabled */
-struct	iw_pmkid_cand
-{
+struct iw_pmkid_cand {
 	__u32		flags; /* IW_PMKID_CAND_* */
 	__u32		index; /* the smaller the index, the higher the
 				* priority */
@@ -884,8 +871,7 @@ struct	iw_pmkid_cand
 /*
  * Wireless statistics (used for /proc/net/wireless)
  */
-struct	iw_statistics
-{
+struct iw_statistics {
 	__u16		status;		/* Status
 					 * - device dependent for now */
 
@@ -897,7 +883,7 @@ struct	iw_statistics
 
 /* ------------------------ IOCTL REQUEST ------------------------ */
 /*
- * This structure defines the payload of an ioctl, and is used 
+ * This structure defines the payload of an ioctl, and is used
  * below.
  *
  * Note that this structure should fit on the memory footprint
@@ -906,8 +892,7 @@ struct	iw_statistics
  * You should check this when increasing the structures defined
  * above in this file...
  */
-union	iwreq_data
-{
+union iwreq_data {
 	/* Config - generic */
 	char		name[IFNAMSIZ];
 	/* Name : used to verify the presence of  wireless extensions.
@@ -944,15 +929,14 @@ union	iwreq_data
  * convenience...
  * Do I need to remind you about structure size (32 octets) ?
  */
-struct	iwreq 
-{
+struct iwreq {
 	union
 	{
 		char	ifrn_name[IFNAMSIZ];	/* if name, e.g. "eth0" */
 	} ifr_ifrn;
 
 	/* Data part (defined just above) */
-	union	iwreq_data	u;
+	union iwreq_data	u;
 };
 
 /* -------------------------- IOCTL DATA -------------------------- */
@@ -965,8 +949,7 @@ struct	iwreq
  *	Range of parameters
  */
 
-struct	iw_range
-{
+struct iw_range {
 	/* Informative stuff (to choose between different interface) */
 	__u32		throughput;	/* To give an idea... */
 	/* In theory this value should be the maximum benchmarked
@@ -1069,9 +1052,8 @@ struct	iw_range
 /*
  * Private ioctl interface information
  */
- 
-struct	iw_priv_args
-{
+
+struct iw_priv_args {
 	__u32		cmd;		/* Number of the ioctl to issue */
 	__u16		set_args;	/* Type and number of args */
 	__u16		get_args;	/* Type and number of args */
@@ -1088,8 +1070,7 @@ struct	iw_priv_args
 /*
  * A Wireless Event. Contains basically the same data as the ioctl...
  */
-struct iw_event
-{
+struct iw_event {
 	__u16		len;			/* Real length of this stuff */
 	__u16		cmd;			/* Wireless IOCTL */
 	union iwreq_data	u;		/* IOCTL fixed payload */
-- 
2.8.0.rc3

